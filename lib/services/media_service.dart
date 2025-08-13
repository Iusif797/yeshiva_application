import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class MediaService {
  final AudioPlayer _player = AudioPlayer();

  Future<File> _cacheFile(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = Uri.parse(url).pathSegments.last;
    final file = File('${dir.path}/audio_$name');
    if (await file.exists()) return file;
    final bytes = await HttpClient().getUrl(Uri.parse(url)).then((r) => r.close()).then((r) => r.fold<List<int>>(<int>[], (p, e) => p..addAll(e))).then((l) => List<int>.from(l));
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> playUrl(String url) async {
    final file = await _cacheFile(url);
    await _player.play(DeviceFileSource(file.path));
  }

  Future<void> pause() => _player.pause();
}


