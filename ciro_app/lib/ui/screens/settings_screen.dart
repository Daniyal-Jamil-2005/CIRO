import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sources = [
      {'n': 'Bluesky', 'st': 'Live', 't': '2 min', 'tone': 'teal', 'icon': LucideIcons.wifi},
      {'n': 'YouTube', 'st': 'Live', 't': '4 min', 'tone': 'teal', 'icon': LucideIcons.wifi},
      {'n': 'RSS Feeds', 'st': 'Live', 't': '1 min', 'tone': 'teal', 'icon': LucideIcons.wifi},
      {'n': 'OpenWeather', 'st': 'Stale', 't': '18 min', 'tone': 'tan', 'icon': LucideIcons.wifi},
      {'n': 'Maps Traffic', 'st': 'Live', 't': '3 min', 'tone': 'teal', 'icon': LucideIcons.wifi},
      {'n': 'PMD', 'st': 'Error', 't': '—', 'tone': 'default', 'icon': LucideIcons.wifiOff},
    ];

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'Settings', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Operating Mode
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'OPERATING MODE',
              style: TextStyle(
                fontSize: 10,
                color: CiroColors.tanText,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: CiroTheme.cardDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: CiroColors.navyLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'LIVE SIGNALS',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'SIMULATED',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: CiroColors.greyText),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 6),
            child: Text(
              'Polling real sources every 5–15 minutes',
              style: TextStyle(fontSize: 10, color: CiroColors.greyText),
            ),
          ),
          const SizedBox(height: 16),

          // Source Health
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'SOURCE HEALTH',
              style: TextStyle(
                fontSize: 10,
                color: CiroColors.tanText,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: CiroTheme.cardDecoration,
            child: Column(
              children: sources.asMap().entries.map((e) {
                final i = e.key;
                final s = e.value;
                final isError = s['st'] == 'Error';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: i != sources.length - 1
                        ? const Border(bottom: BorderSide(color: Color(0xFFEEF2F5)))
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(s['icon'] as IconData, size: 14, color: isError ? CiroColors.danger : CiroColors.tealPrimary),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s['n'] as String, style: const TextStyle(fontSize: 12, color: CiroColors.navyText)),
                              const SizedBox(height: 2),
                              Text('Last poll ${s['t']}', style: const TextStyle(fontSize: 9, color: CiroColors.greyText)),
                            ],
                          ),
                        ],
                      ),
                      CiroChip(text: s['st'] as String, tone: s['tone'] as String),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: CiroColors.greyBorder),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Force Refresh All',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: CiroColors.navyText),
            ),
          ),
          const SizedBox(height: 16),

          // About
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'ABOUT',
              style: TextStyle(
                fontSize: 10,
                color: CiroColors.tanText,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: CiroTheme.cardDecoration,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Version', style: TextStyle(fontSize: 11, color: CiroColors.greyText)),
                    Text('1.0.0', style: TextStyle(fontSize: 11, color: CiroColors.navyText)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Hackathon', style: TextStyle(fontSize: 11, color: CiroColors.greyText)),
                    Text('Antigravity 2026', style: TextStyle(fontSize: 11, color: CiroColors.navyText)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Challenge', style: TextStyle(fontSize: 11, color: CiroColors.greyText)),
                    Text('#3', style: TextStyle(fontSize: 11, color: CiroColors.navyText)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
