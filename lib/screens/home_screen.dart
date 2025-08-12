import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/word_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.35,
      drawer: const _AppDrawer(),
      body: Stack(
        children: [
          // Modern gradient background with blurred blobs
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(0.18),
                    colorScheme.tertiary.withOpacity(0.10),
                    colorScheme.secondary.withOpacity(0.08),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -40,
            child: _GlowBlob(color: colorScheme.primary.withOpacity(0.35), size: 220),
          ),
          Positioned(
            bottom: -60,
            right: -30,
            child: _GlowBlob(color: colorScheme.secondary.withOpacity(0.30), size: 200),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yeshiva Torah Learning',
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, curve: Curves.easeOutCubic),
                  const SizedBox(height: 8),
                  Text(
                    'Изучай тексты Торы и слова через PDF и DuoCards',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ).animate(delay: 200.ms).fadeIn().moveY(begin: 8, curve: Curves.easeOutCubic),
                  const SizedBox(height: 28),
                  const _ProgressBar(),
                  const SizedBox(height: 20),
                  _NavGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.98,
        ),
        padding: const EdgeInsets.only(bottom: 12),
        children: [
          _NavCard(
            icon: Icons.picture_as_pdf_rounded,
            title: 'PDF Просмотр',
            subtitle: 'Открывай и читай PDF',
            color: colorScheme.primary,
            onTap: () => context.go('/pdf'),
          ),
          _NavCard(
            icon: Icons.spellcheck_rounded,
            title: 'Извлечь слова',
            subtitle: 'Анализ текста PDF',
            color: colorScheme.tertiary,
            onTap: () => context.go('/extract'),
          ),
          _NavCard(
            icon: Icons.view_carousel_rounded,
            title: 'DuoCards',
            subtitle: 'Свайп-запоминание',
            color: colorScheme.secondary,
            onTap: () => context.go('/duocards'),
          ),
          _NavCard(
            icon: Icons.settings_suggest_rounded,
            title: 'Настройки',
            subtitle: 'Тема, язык, TTS',
            color: colorScheme.surfaceTint,
            onTap: () {},
          ),
        ].animate(interval: 100.ms).fadeIn(duration: 350.ms).scale(begin: const Offset(0.96, 0.96)),
      ),
    );
  }
}

class _ProgressBar extends StatefulWidget {
  const _ProgressBar();
  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBarState extends State<_ProgressBar> {
  int _wordCount = 0;
  int _learned = 0;
  int _reviewed = 0;
  int _sessions = 0;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final count = (await WordRepository().getAll()).length;
    if (mounted) setState(() => _wordCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 6))],
        border: Border.all(color: Colors.white.withOpacity(0.14), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Прогресс слов', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: (_wordCount % 100) / 100.0,
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text('В словаре: $_wordCount', style: GoogleFonts.inter(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.75))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _StatChip(label: 'Выучено', value: _learned, color: Colors.green),
              _StatChip(label: 'Повторено', value: _reviewed, color: Colors.orange),
              _StatChip(label: 'Сессии', value: _sessions, color: Colors.blue),
              _StatChip(label: 'Серия', value: _streak, color: Colors.purple),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text('$label: $value', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary.withOpacity(0.18), cs.secondary.withOpacity(0.14), cs.tertiary.withOpacity(0.12)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('Главная'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded),
                  title: const Text('PDF Просмотр'),
                  onTap: () => context.go('/pdf'),
                ),
                ListTile(
                  leading: const Icon(Icons.spellcheck_rounded),
                  title: const Text('Извлечь слова'),
                  onTap: () => context.go('/extract'),
                ),
                ListTile(
                  leading: const Icon(Icons.view_carousel_rounded),
                  title: const Text('DuoCards'),
                  onTap: () => context.go('/duocards'),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Text('Ваш прогресс', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                const _ProgressBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.18),
            width: 1.2,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7))),
          ],
        ),
      ),
    ).animate().scale(begin: const Offset(0.98, 0.98)).moveY(begin: 4);
  }
}


