import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'sev': 'CRITICAL',
        'type': 'Flash Flood',
        'city': 'Gulberg, Lahore',
        'en': 'Critical flood detected. Avoid MM Alam Road. Alt route via Boulevard active.',
        'ur': 'MM Alam Road bandh hai. Boulevard se jayein.',
        'time': '2 min',
        'unread': true,
      },
      {
        'sev': 'HIGH',
        'type': 'Road Blockage',
        'city': 'Korangi, Karachi',
        'en': 'Major congestion on Korangi Crossing — rescue route activated.',
        'ur': 'Korangi Crossing par traffic jam.',
        'time': '18 min',
        'unread': true,
      },
      {
        'sev': 'RESOLVED',
        'type': 'Heatwave',
        'city': 'Islamabad',
        'en': 'Heatwave advisory cleared. Temperatures normalising.',
        'ur': 'Garmi ki warning khatam.',
        'time': '2 h',
        'unread': false,
      },
    ];

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: TopBar(
        title: 'Alert History',
        showBack: true,
        right: const Text(
          'Mark all read',
          style: TextStyle(
            color: CiroColors.tanText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['Unread', 'All', 'Today', 'Week'].map((t) {
                final isSelected = t == 'Unread';
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? CiroColors.navyLight : Colors.white,
                    border: Border.all(
                      color: isSelected ? CiroColors.navyLight : CiroColors.greyBorder,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    t,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : CiroColors.greyDark,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final n = items[index];
                final unread = n['unread'] as bool;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: CiroTheme.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SeverityBadge(level: n['sev'] as String),
                                  const SizedBox(width: 8),
                                  Text(
                                    n['type'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: CiroColors.navyText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${n['time']} ago',
                                style: const TextStyle(fontSize: 9, color: CiroColors.greyText),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(LucideIcons.mapPin, size: 9, color: CiroColors.greyText),
                              const SizedBox(width: 4),
                              Text(
                                n['city'] as String,
                                style: const TextStyle(fontSize: 10, color: CiroColors.greyText),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            n['en'] as String,
                            style: const TextStyle(fontSize: 11, color: CiroColors.navyText, height: 1.3),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            n['ur'] as String,
                            style: const TextStyle(fontSize: 10, color: CiroColors.greyText, fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCEEF3),
                                  border: Border.all(color: const Color(0xFFBCDDE5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'View Crisis',
                                  style: TextStyle(fontSize: 10, color: CiroColors.tealDark),
                                ),
                              ),
                              if (unread) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: CiroColors.greyBorder),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Mark read',
                                    style: TextStyle(fontSize: 10, color: CiroColors.greyDark),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (unread)
                      Positioned(
                        left: -4,
                        top: 30, // Approximate center vertically, adjust as needed
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: CiroColors.tealPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: 'More'),
    );
  }
}
