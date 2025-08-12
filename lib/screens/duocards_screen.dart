import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/word_repository.dart';
import '../services/translation_service.dart';

final wordsProvider = FutureProvider<List<String>>((ref) async {
  final repo = WordRepository();
  final words = await repo.getAll();
  if (words.isEmpty) {
    return const ['שלום', 'תודה', 'בבקשה', 'ספר', 'ללמוד', 'אור'];
  }
  return words;
});

class DuoCardsScreen extends ConsumerStatefulWidget {
  const DuoCardsScreen({super.key});

  @override
  ConsumerState<DuoCardsScreen> createState() => _DuoCardsScreenState();
}

class _DuoCardsScreenState extends ConsumerState<DuoCardsScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragOffsetX = 0;
  late AnimationController _animController;
  late Animation<double> _anim;
  String? _currentTranslation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _speak(String text) {}

  void _onSwipe(double deltaX) {
    final words = ref.read(wordsProvider).asData?.value ?? const <String>[];
    setState(() => _dragOffsetX += deltaX);
    if (_dragOffsetX.abs() > 120 && words.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % words.length;
        _dragOffsetX = 0;
        _currentTranslation = null;
      });
      _animController.forward(from: 0);
      // Учёт статистики
      // Для упрощения: каждая карточка считается как повторение
      // Переносим на репозиторий при необходимости
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('DuoCards')),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
        data: (words) {
          final current = words[_currentIndex % words.length];
          final next = words[(max(0, _currentIndex) + 1) % words.length];
          _prefetchTranslation(current);
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildCard(next, scale: 0.94, opacity: 0.6),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, child) {
                    final slideX = _dragOffsetX * (1 - _anim.value) + 24 * _anim.value;
                    final angle = (_dragOffsetX / 300) * 0.15 * (1 - _anim.value);
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(slideX)
                        ..rotateZ(angle),
                      child: child,
                    );
                  },
                  child: _buildCard(current),
                ),
                Positioned(
                  bottom: 40,
                  child: AnimatedOpacity(
                    opacity: _currentTranslation == null ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: _currentTranslation == null
                        ? const SizedBox.shrink()
                        : _TranslationBadge(text: _currentTranslation!),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Row(
          children: [
            _RoundButton(icon: Icons.volume_up_rounded, onTap: () => _speak('')),
            const SizedBox(width: 12),
            Expanded(
              child: _PrimaryButton(
                label: 'Знаю',
                color: Colors.green,
                onTap: () => _onSwipe(200),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PrimaryButton(
                label: 'Учить',
                color: Colors.orange,
                onTap: () => _onSwipe(-200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _prefetchTranslation(String word) async {
    if (_currentTranslation != null) return;
    final service = TranslationService();
    final t = await service.translateHeToRu(word);
    if (mounted) setState(() => _currentTranslation = t);
  }

  Widget _buildCard(String text, {double scale = 1, double opacity = 1}) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) => _onSwipe(d.delta.dx),
      onHorizontalDragEnd: (_) {
        if (_dragOffsetX.abs() < 120) {
          setState(() => _dragOffsetX = 0);
        }
      },
      onTap: () => _speak(text),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.84,
            height: min(520, MediaQuery.of(context).size.height * 0.62),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 26, offset: const Offset(0, 14)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 58, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}

class _TranslationBadge extends StatelessWidget {
  final String text;
  const _TranslationBadge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Icon(icon),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }
}


