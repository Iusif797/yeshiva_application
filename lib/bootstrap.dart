import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // ignore if no env file
  }
  runApp(const ProviderScope(child: YeshivaLearningApp()));
}


