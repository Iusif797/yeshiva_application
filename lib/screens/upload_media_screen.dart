import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/media_service.dart';
import '../widgets/upload_preview.dart';

class UploadMediaScreen extends StatefulWidget {
  const UploadMediaScreen({super.key});
  @override
  State<UploadMediaScreen> createState() => _UploadMediaScreenState();
}

class _UploadMediaScreenState extends State<UploadMediaScreen> {
  File? _file;
  String? _url;
  int _sent = 0;
  int _total = 0;
  bool _loading = false;
  String? _error;

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp3', 'wav', 'm4a', 'mp4', 'mov', 'mkv']);
    if (res != null && res.files.single.path != null) {
      setState(() {
        _file = File(res.files.single.path!);
        _url = null;
        _error = null;
      });
    }
  }

  Future<void> _upload() async {
    if (_file == null) return;
    setState(() {
      _loading = true;
      _error = null;
      _sent = 0;
      _total = 0;
    });
    try {
      final api = context.read<ApiService>();
      final res = await api.uploadMedia(_file!, onSendProgress: (s, t) => setState(() {
            _sent = s;
            _total = t;
          }));
      final url = res['url']?.toString() ?? res['file_url']?.toString();
      if (url == null || url.isEmpty) throw Exception('no url');
      setState(() => _url = url);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploaded')));
      await MediaService().pause();
    } catch (e) {
      setState(() => _error = e.toString());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${_error!}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Media')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(onPressed: _loading ? null : _pick, icon: const Icon(Icons.attach_file), label: const Text('Choose file')),
            const SizedBox(height: 12),
            if (_file != null) UploadPreview(file: _file!),
            if (_loading && _total > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(value: _total == 0 ? null : _sent / _total),
              ),
            const Spacer(),
            ElevatedButton.icon(onPressed: _file == null || _loading ? null : _upload, icon: const Icon(Icons.cloud_upload_rounded), label: const Text('Upload')),
            const SizedBox(height: 12),
            if (_url != null)
              SelectableText(_url!, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}


