import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bootstrap.dart';
import 'config.dart';
import 'storage/hive_adapters.dart';
import 'app.dart';

Future<void> main() async {
  await registerHiveAdapters();
  await bootstrap();
}
