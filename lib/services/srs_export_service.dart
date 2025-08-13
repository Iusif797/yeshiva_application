import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/lexeme.dart';
import 'api_service.dart';

class SrsExportService {
  final ApiService api;
  SrsExportService(this.api);

  Future<String> buildCsv(List<Lexeme> items) async {
    final rows = <List<dynamic>>[];
    rows.add(['display_text', 'gloss', 'explanation', 'note', 'audio_url']);
    for (final l in items) {
      final gloss = l.senses.isNotEmpty ? l.senses.first.gloss : '';
      final expl = l.senses.isNotEmpty ? l.senses.first.explanation : '';
      rows.add([l.displayText, gloss, expl, '', l.audioUrl ?? '']);
    }
    final csv = const ListToCsvConverter(fieldDelimiter: ';', eol: '\n').convert(rows);
    return csv;
  }

  Future<void> exportRemote(int studentId, String provider, List<int> ids) async {
    final res = await api.exportToSrs(studentId, provider, ids);
    final url = res['file_url']?.toString();
    if (url == null || url.isEmpty) throw ApiException('no_file');
  }

  Future<String> saveLocalCsv(String csv, {String? name}) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${name ?? 'export'}.csv';
    final f = File(path);
    await f.writeAsString(csv, encoding: utf8);
    return path;
  }

  Future<void> shareCsvPath(String path) async {
    await Share.shareXFiles([XFile(path)], text: 'SRS Export');
  }
}


