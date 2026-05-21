import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../components/global_components.dart';
import '../../providers/app_state.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signals = ref.watch(signalsProvider);
    final isGlobal = ref.watch(regionProvider);
    final visibleSignals = isGlobal
        ? signals
        : signals.where(_isPakistanSignal).toList(growable: false);

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'Signal Feed'),
      body: Column(
        children: [
          // Header toggles
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: CiroColors.greyBorder),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => ref
                              .read(regionProvider.notifier)
                              .setGlobal(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: !isGlobal
                                  ? CiroColors.navyLight
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Pakistan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !isGlobal
                                    ? Colors.white
                                    : CiroColors.greyText,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              ref.read(regionProvider.notifier).setGlobal(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isGlobal
                                  ? CiroColors.navyLight
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Global',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isGlobal
                                    ? Colors.white
                                    : CiroColors.greyText,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: CiroColors.tealPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'LIVE STREAM',
                      style: TextStyle(
                        fontSize: 10,
                        color: CiroColors.tealDark,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: ['All', 'Social', 'News', 'Weather', 'Traffic'].map((
                t,
              ) {
                final isSelected = t == 'All';
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? CiroColors.navyLight : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? CiroColors.navyLight
                          : CiroColors.greyBorder,
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
            child: visibleSignals.isEmpty
                ? const Center(child: Text('No signals detected.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                    itemCount: visibleSignals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final s = visibleSignals[index];
                      final String rawText = s['raw_text'] ?? '';
                      final String source = s['source'] ?? 'UNKNOWN';
                      final String type = s['event_type_hint'] ?? 'UNKNOWN';
                      final String loc = s['location_hint'] ?? 'UNKNOWN';
                      final int conf = s['credibility_score'] ?? 0;
                      final String timeAgo = s['time_ago'] ?? 'Just now';

                      IconData iconData = LucideIcons.radio;
                      if (source == 'BLUESKY')
                        iconData = LucideIcons.messageSquare;
                      if (source == 'WEATHER') iconData = LucideIcons.wind;
                      if (source == 'NEWS') iconData = LucideIcons.newspaper;
                      if (source == 'TWITTER') iconData = LucideIcons.atSign;

                      return Container(
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
                                    Icon(
                                      iconData,
                                      size: 12,
                                      color: CiroColors.tealDark,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      source,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: CiroColors.navyText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  timeAgo,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: CiroColors.greyText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: [
                                CiroChip(text: source, tone: 'teal'),
                                CiroChip(
                                  text: s['language'] ?? 'ENGLISH',
                                  icon: LucideIcons.languages,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              rawText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CiroColors.navyText,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CrisisIcon(
                                      type: type,
                                      size: 11,
                                      color: CiroColors.greyDark,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$type · $loc',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: CiroColors.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '+$conf conf',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: CiroColors.tealDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: 'Feed'),
    );
  }
}

bool _isPakistanSignal(Map<String, dynamic> signal) {
  final text = '${signal['location_hint'] ?? ''} ${signal['raw_text'] ?? ''}'
      .toLowerCase();
  return RegExp(
    r'lahore|karachi|islamabad|rawalpindi|peshawar|quetta|faisalabad|multan|sindh|punjab|balochistan|khyber|pakistan|gulberg|dha|canal road|jacobabad|korangi',
  ).hasMatch(text);
}
