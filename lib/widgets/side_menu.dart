import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final ValueChanged<String>? onSelect;
  const SideMenu({super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      const _MenuItem('Главная', Icons.home, '/'),
      const _MenuItem('Курсы', Icons.menu_book, '/'),
      const _MenuItem('Уроки', Icons.menu, '/course'),
      const _MenuItem('Слова', Icons.translate, '/new_words'),
      const _MenuItem('Загрузки', Icons.upload_file, '/upload_media'),
      const _MenuItem('Inbox', Icons.inbox, '/teacher/inbox'),
      const _MenuItem('Профиль', Icons.person, '/profile'),
      const _MenuItem('Рейтинг', Icons.emoji_events, '/leaderboard'),
      const _MenuItem('Настройки', Icons.settings, '/profile'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 900;
      final menu = Container(
        width: isWide ? 280 : double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 48, height: 48, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24)),
                const SizedBox(width: 12),
                Expanded(child: Text('Yeshiva', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
              ]),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (ctx, i) {
                    final it = items[i];
                    return _SideMenuRow(item: it, onTap: () {
                      onSelect?.call(it.route);
                      if (!isWide) Navigator.of(context).maybePop();
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: ElevatedButton(onPressed: () => onSelect?.call('/profile'), child: const Text('Аккаунт'))),
              ]),
            ],
          ),
        ),
      );
      if (isWide) return menu;
      return Drawer(child: menu);
    });
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  const _MenuItem(this.title, this.icon, this.route);
}

class _SideMenuRow extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback? onTap;
  const _SideMenuRow({required this.item, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                child: Icon(item.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
              const Icon(Icons.chevron_right, color: Colors.white70)
            ],
          ),
        ),
      ),
    );
  }
}


