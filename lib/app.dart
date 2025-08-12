import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class YeshivaLearningApp extends ConsumerWidget {
  const YeshivaLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = buildAppTheme();
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Yeshiva Torah Learning',
      themeMode: ThemeMode.system,
      theme: theme.light,
      darkTheme: theme.dark,
      routerConfig: router,
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}


