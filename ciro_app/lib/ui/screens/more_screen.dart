import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';
import 'trace_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'volunteer_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'n': 'Agent Trace', 'd': 'View AI pipeline execution', 'icon': LucideIcons.gitBranch, 'route': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TraceScreen()))},
      {'n': 'Disaster Directory', 'd': 'Browse all detected crises', 'icon': LucideIcons.filter, 'route': () {}},
      {'n': 'Volunteer Network', 'd': 'Join response teams', 'icon': LucideIcons.users, 'route': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VolunteerScreen()))},
      {'n': 'Notifications', 'd': 'Alert history', 'icon': LucideIcons.bell, 'badge': '7', 'route': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))},
      {'n': 'Settings & Health', 'd': 'System config & status', 'icon': LucideIcons.settings, 'route': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))},
      {'n': 'About CIRO', 'd': 'Version & credits', 'icon': LucideIcons.info, 'route': () {}},
    ];

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'More'),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: item['route'] as VoidCallback,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: CiroTheme.cardDecoration,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEEF3),
                      border: Border.all(color: const Color(0xFFBCDDE5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item['icon'] as IconData, size: 16, color: CiroColors.tealDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['n'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CiroColors.navyText)),
                        const SizedBox(height: 2),
                        Text(item['d'] as String, style: const TextStyle(fontSize: 10, color: CiroColors.greyText)),
                      ],
                    ),
                  ),
                  if (item['badge'] != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CiroColors.danger,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['badge'] as String,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFFCDD5DC)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(active: 'More'),
    );
  }
}
