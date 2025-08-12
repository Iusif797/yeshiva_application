import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart';

class TextExtractorService {
  Future<String> extractText(String path) async {
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) return _extractFromPdf(path);
    if (lower.endsWith('.docx')) return _extractFromDocx(path);
    if (lower.endsWith('.txt')) return File(path).readAsString();
    // Fallback: try as text
    return File(path).readAsString();
  }

  Future<String> extractTextFromBytes(Uint8List bytes, String extension) async {
    final lower = extension.toLowerCase();
    if (lower == 'pdf') return _extractFromPdfBytes(bytes);
    if (lower == 'docx') return _extractFromDocxBytes(bytes);
    if (lower == 'txt') return String.fromCharCodes(bytes);
    return String.fromCharCodes(bytes);
  }

  Future<String> _extractFromPdf(String path) async {
    final bytes = await File(path).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final textExtractor = PdfTextExtractor(document);
    final text = textExtractor.extractText();
    document.dispose();
    return text;
  }

  Future<String> _extractFromPdfBytes(Uint8List bytes) async {
    final document = PdfDocument(inputBytes: bytes);
    final textExtractor = PdfTextExtractor(document);
    final text = textExtractor.extractText();
    document.dispose();
    return text;
  }

  Future<String> _extractFromDocx(String path) async {
    final bytes = await File(path).readAsBytes();
    return _extractFromDocxBytes(bytes);
  }

  Future<String> _extractFromDocxBytes(Uint8List bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final documentXml = archive.findFile('word/document.xml');
    if (documentXml == null) return '';
    final content = documentXml.content as List<int>;
    final xmlStr = String.fromCharCodes(Uint8List.fromList(content));
    final doc = XmlDocument.parse(xmlStr);
    final buffer = StringBuffer();
    const wNs = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';
    for (final node in doc.findAllElements('t', namespace: wNs)) {
      buffer.write(node.text);
      buffer.write(' ');
    }
    return buffer.toString();
  }
}


