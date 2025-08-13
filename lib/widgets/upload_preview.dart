import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UploadPreview extends StatelessWidget {
  final File file;
  const UploadPreview({super.key, required this.file});
  @override
  Widget build(BuildContext context) {
    final size = file.lengthSync();
    final pretty = NumberFormat.compact().format(size);
    final name = file.path.split(Platform.pathSeparator).last;
    final isAudio = name.toLowerCase().endsWith('.mp3') || name.toLowerCase().endsWith('.wav') || name.toLowerCase().endsWith('.m4a');
    return ListTile(
      leading: CircleAvatar(child: Icon(isAudio ? Icons.audiotrack : Icons.movie_creation_rounded)),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('$pretty bytes'),
    );
  }
}


