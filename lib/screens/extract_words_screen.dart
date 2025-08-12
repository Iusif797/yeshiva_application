import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/text_extractor.dart';
import '../data/word_repository.dart';
import '../services/llm_lesson_service.dart';
import 'package:go_router/go_router.dart';

class ExtractWordsScreen extends StatefulWidget {
  const ExtractWordsScreen({super.key});

  @override
  State<ExtractWordsScreen> createState() => _ExtractWordsScreenState();
}

class _ExtractWordsScreenState extends State<ExtractWordsScreen> {
  String? _filePath;
  bool _loading = false;
  List<String> _hebrewWords = [];
  String? _error;

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
      withData: true,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _filePath = file.path; // may be null on Web
        _hebrewWords = [];
        _error = null;
      });
    }
  }

  Future<void> _extract() async {
    if (_filePath == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final extractor = TextExtractorService();
      String text;
      final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
        withData: true,
      );
      if (file != null && file.files.single.bytes != null) {
        final name = file.files.single.name;
        final ext = name.contains('.') ? name.split('.').last : '';
        text = await extractor.extractTextFromBytes(file.files.single.bytes!, ext);
      } else if (_filePath != null) {
        text = await extractor.extractText(_filePath!);
      } else {
        throw 'Файл не выбран';
      }
      final normalized = text.replaceAll('\n', ' ');
      final regex = RegExp(r"[\u0590-\u05FF\uFB1D-\uFB4F]+", multiLine: true);
      final matches = regex.allMatches(normalized).map((m) => m.group(0)!).toList();
      final unique = matches.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
      unique.sort((a, b) => a.compareTo(b));
      setState(() => _hebrewWords = unique);
      await WordRepository().addWords(unique);
      // Сгенерировать урок на базе текста и перейти на экран урока
      final lessonJson = await LlmLessonService().generateLesson(text);
      if (mounted) context.go('/lesson', extra: lessonJson);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Извлечение слов из PDF')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'pick',
            onPressed: _pickPdf,
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('Выбрать PDF'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'extract',
            onPressed: _filePath == null || _loading ? null : _extract,
            icon: const Icon(Icons.spellcheck_rounded),
            label: const Text('Извлечь слова'),
          ),
        ],
      ),
      body: _filePath == null
          ? const _EmptyState()
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _hebrewWords.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final word = _hebrewWords[index];
                        return ListTile(
                          title: Text(word, textDirection: TextDirection.rtl),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                        );
                      },
                    ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.text_snippet_rounded, size: 80, color: Colors.grey),
          SizedBox(height: 12),
          Text('Выберите PDF и извлеките слова'),
        ],
      ),
    );
  }
}


