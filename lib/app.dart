import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/role_provider.dart';
import 'providers/auth_provider.dart' as app;
import 'providers/course_provider.dart' as cprov;
import 'providers/new_words_provider.dart' as nwprov;
import 'services/api_service.dart';
import 'config.dart';

class YeshivaLearningApp extends ConsumerWidget {
  const YeshivaLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = buildAppTheme();
    final router = ref.watch(appRouterProvider);
    return p.MultiProvider(
      providers: [
        p.ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
        p.ChangeNotifierProvider(create: (_) => RoleProvider()..load()),
        p.ChangeNotifierProvider(create: (_) => app.AuthProvider()),
        p.Provider<ApiService>(
          create: (ctx) => ApiService(
            onUnauthorized: () => ctx.read<app.AuthProvider>().clear(),
          ),
        ),
        p.ChangeNotifierProvider(create: (ctx) => cprov.CourseProvider(ctx.read<ApiService>())),
        p.ChangeNotifierProvider(create: (ctx) => nwprov.NewWordsProvider(ctx.read<ApiService>())),
      ],
      child: p.Consumer<ThemeProvider>(builder: (context, t, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Yeshiva Torah Learning',
          themeMode: t.mode,
          theme: theme.light,
          darkTheme: theme.dark,
          routerConfig: router,
          supportedLocales: const [Locale('en'), Locale('ru')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return DefaultTextStyle.merge(
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      }),
    );
  }
}


