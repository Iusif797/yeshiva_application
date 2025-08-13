import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/role_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final role = context.watch<RoleProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.phone_android)),
              ],
              selected: {theme.mode},
              onSelectionChanged: (s) => context.read<ThemeProvider>().setMode(s.first),
            ),
            const SizedBox(height: 24),
            const Text('Role', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            SegmentedButton<AppRole>(
              segments: const [
                ButtonSegment(value: AppRole.student, label: Text('Student'), icon: Icon(Icons.school)),
                ButtonSegment(value: AppRole.admin, label: Text('Admin'), icon: Icon(Icons.admin_panel_settings)),
              ],
              selected: {role.role},
              onSelectionChanged: (s) => context.read<RoleProvider>().setRole(s.first),
            ),
          ],
        ),
      ),
    );
  }
}


