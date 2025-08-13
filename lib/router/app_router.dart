import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/app_shell.dart';
import '../screens/pdf_viewer_screen.dart';
import '../screens/extract_words_screen.dart';
import '../screens/duocards_screen.dart';
import '../screens/lesson_screen.dart';
import '../screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: 'pdf',
            builder: (context, state) => const PdfViewerScreen(),
          ),
          GoRoute(
            path: 'extract',
            builder: (context, state) => const ExtractWordsScreen(),
          ),
          GoRoute(
            path: 'duocards',
            builder: (context, state) => const DuoCardsScreen(),
          ),
          GoRoute(
            path: 'lesson',
            builder: (context, state) {
              final data = state.extra as String?;
              return LessonScreen(lessonJson: data ?? '');
            },
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});


