import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = [
      {'label': 'FLOOD', 'val': 42, 'color': const Color(0xFF5FA3B8)},
      {'label': 'FIRE', 'val': 28, 'color': const Color(0xFFE07A3C)},
      {'label': 'ROAD', 'val': 18, 'color': const Color(0xFFD4A93C)},
      {'label': 'HEAT', 'val': 12, 'color': const Color(0xFFD04545)},
    ];

    final cities = [
      {'name': 'Lahore', 'count': 78},
      {'name': 'Karachi', 'count': 61},
      {'name': 'Islamabad', 'count': 42},
      {'name': 'Peshawar', 'count': 28},
    ];

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'Analytics'),
      body: Column(
        children: [
          // Search / Ask Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: CiroTheme.cardDecoration,
              child: Row(
                children: [
                  const Icon(LucideIcons.search, size: 14, color: CiroColors.greyText),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Ask about crisis data…',
                      style: TextStyle(fontSize: 11, color: CiroColors.greyText),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [CiroColors.tanGradientStart, CiroColors.tanGradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Ask',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['Floods in Karachi', 'Top cities', 'Avg response', 'Resolved today'].map((t) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: CiroColors.greyBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(fontSize: 10, color: CiroColors.greyDark),
                  ),
                );
              }).toList(),
            ),
          ),

          // Main content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
              children: [
                // Total Crises Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: CiroTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL CRISES',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: CiroColors.tanText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            '247',
                            style: TextStyle(fontSize: 28, height: 1.0, fontWeight: FontWeight.w600, color: CiroColors.navyText),
                          ),
                          SizedBox(width: 8),
                          Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              '↑ 18%',
                              style: TextStyle(fontSize: 11, color: CiroColors.success),
                            ),
                          ),
                        ],
                      ),
                      const Text('vs last 30 days', style: TextStyle(fontSize: 10, color: CiroColors.greyText)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // By Type Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: CiroTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'BY TYPE',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: CiroColors.tanText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...bars.map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 48,
                                  child: Text(
                                    b['label'] as String,
                                    style: const TextStyle(fontSize: 10, color: CiroColors.greyDark),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF2F5),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: (b['val'] as int) / 100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: b['color'] as Color,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${b['val']}%',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 10, color: CiroColors.navyText),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Top Cities Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: CiroTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOP CITIES',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: CiroColors.tanText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...cities.asMap().entries.map((e) {
                        final i = e.key;
                        final c = e.value;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: i != cities.length - 1
                                ? const Border(bottom: BorderSide(color: Color(0xFFEEF2F5)))
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${i + 1}. ${c['name']}', style: const TextStyle(fontSize: 11, color: CiroColors.greyDark)),
                              Text('${c['count']} events', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: CiroColors.tealDark)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Avg Response Time Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: CiroTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AVG RESPONSE TIME',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 1.5,
                          color: CiroColors.tanText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('42s', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: CiroColors.tealPrimary)),
                                Text('Detection→Response', style: TextStyle(fontSize: 9, color: CiroColors.greyText)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('18m', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: CiroColors.success)),
                                Text('Detection→Resolved', style: TextStyle(fontSize: 9, color: CiroColors.greyText)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: 'Analytics'),
    );
  }
}
