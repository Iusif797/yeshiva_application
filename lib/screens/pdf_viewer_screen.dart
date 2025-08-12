import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _filePath;
  final PdfViewerController _controller = PdfViewerController();
  String errorMessage = '';

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Просмотр')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickPdf,
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Открыть PDF'),
      ),
      body: _filePath == null
          ? const _EmptyState()
          : Stack(
              children: [
                // На Web не читаем локальный путь; покажем подсказку.
                kIsWeb
                    ? const Center(child: Text('Откройте PDF через экран "Извлечь слова"'))
                    : SfPdfViewer.file(
                  File(_filePath!),
                  controller: _controller,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  enableDoubleTapZooming: true,
                  onDocumentLoaded: (_) {},
                  onDocumentLoadFailed: (details) {
                    setState(() => errorMessage = details.description);
                  },
                ),
                if (errorMessage.isNotEmpty)
                  Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red))),
              ],
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
          Icon(Icons.picture_as_pdf_rounded, size: 80, color: Colors.grey),
          SizedBox(height: 12),
          Text('Выберите PDF для просмотра'),
        ],
      ),
    );
  }
}


