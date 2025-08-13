import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/side_menu.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 900;
      return Scaffold(
        drawer: isWide ? null : SideMenu(onSelect: (route) => context.go(route)),
        body: Row(
          children: [
            if (isWide) SizedBox(width: 280, child: SideMenu(onSelect: (route) => context.go(route))),
            Expanded(
              child: Column(
                children: [
                  AppBar(title: const Text('Yeshiva Torah Learning'), actions: [
                    IconButton(icon: const Icon(Icons.person), onPressed: () => context.go('/profile')),
                  ]),
                  Expanded(child: child),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}


