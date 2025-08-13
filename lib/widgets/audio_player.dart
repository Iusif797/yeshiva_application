import 'package:flutter/material.dart';
import '../services/media_service.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;
  const AudioPlayerWidget({super.key, required this.url});
  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool playing = false;
  final MediaService _media = MediaService();

  Future<void> _toggle() async {
    if (!playing) {
      await _media.playUrl(widget.url);
      setState(() => playing = true);
    } else {
      await _media.pause();
      setState(() => playing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill), onPressed: _toggle);
  }
}


