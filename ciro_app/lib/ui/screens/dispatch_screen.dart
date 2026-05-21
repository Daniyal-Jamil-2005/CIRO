import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_state.dart';
import '../../utils/crisis_display.dart';

class DispatchScreen extends ConsumerWidget {
  const DispatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(ticketsProvider);
    final crises = ref.watch(crisesProvider);
    final activeCrisis = crises.isNotEmpty ? crises.first : null;
    final activeTitle = activeCrisis != null
        ? CrisisDisplay.summary(activeCrisis)
        : 'No active crisis';
    final activeSeverity = activeCrisis != null
        ? CrisisDisplay.severity(activeCrisis)
        : 'MEDIUM';
    final activePlan = activeCrisis != null
        ? (activeCrisis['response_plan'] ?? 'No response plan available yet.')
        : 'Awaiting a detected crisis before dispatching services.';

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'Dispatch Command'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Emergency Header
            const Text(
              'ACTIVE OPERATIONS',
              style: TextStyle(
                fontSize: 10,
                color: CiroColors.greyText,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: CiroTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activeTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CiroColors.navyText,
                        ),
                      ),
                      SeverityBadge(level: activeSeverity),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CiroColors.navyLight.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CiroColors.navyLight.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          LucideIcons.bot,
                          size: 16,
                          color: CiroColors.tealDark,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: CiroColors.navyText,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Agent 4 Assessment: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '$activePlan'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dispatched Services
            const Text(
              'DISPATCHED SERVICES',
              style: TextStyle(
                fontSize: 10,
                color: CiroColors.greyText,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            if (tickets.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No active dispatch tickets.',
                  style: TextStyle(color: CiroColors.greyText),
                ),
              ),

            ...tickets.map((t) {
              IconData iconData = LucideIcons.siren;
              if (t['icon'] == 'flame') iconData = LucideIcons.flame;
              if (t['icon'] == 'heartPulse') iconData = LucideIcons.heartPulse;
              if (t['icon'] == 'droplet') iconData = LucideIcons.droplets;
              if (t['icon'] == 'shield') iconData = LucideIcons.shield;
              if (t['icon'] == 'zap') iconData = LucideIcons.zap;

              String tone = 'default';
              final status = t['status'] ?? 'Unknown';
              if (status == 'Alerted') tone = 'teal';
              if (status == 'Dispatched') tone = 'danger';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDispatchCard(
                  icon: iconData,
                  title: t['service'] ?? 'Emergency Service',
                  status: '${t['status']} - ${t['action']}',
                  eta: t['eta'] ?? 'N/A',
                  statusTone: tone,
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Mini Map Placeholder
            const Text(
              'LIVE TRACKING',
              style: TextStyle(
                fontSize: 10,
                color: CiroColors.greyText,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CiroColors.greyBorder),
                image: const DecorationImage(
                  image: AssetImage('assets/images/map_bg.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Live map tracking initializing...',
                      style: TextStyle(
                        fontSize: 12,
                        color: CiroColors.navyText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CiroColors.greyBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: CiroColors.tealPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: CiroColors.tealDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(active: 'Dispatch'),
    );
  }

  Widget _buildDispatchCard({
    required IconData icon,
    required String title,
    required String status,
    required String eta,
    required String statusTone,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: CiroTheme.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CiroColors.navyLight.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: CiroColors.navyLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: CiroColors.navyText,
                      ),
                    ),
                    Text(
                      eta,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: CiroColors.navyLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                CiroChip(text: status, tone: statusTone),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
