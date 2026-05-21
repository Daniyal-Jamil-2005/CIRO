import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';
import 'deep_dive_screen.dart';
import '../../utils/crisis_display.dart';

class CrisisDetailSheet extends StatelessWidget {
  final Map<String, dynamic> crisis;
  const CrisisDetailSheet({super.key, required this.crisis});

  static void show(BuildContext context, Map<String, dynamic> crisis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CrisisDetailSheet(crisis: crisis),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeLabel = CrisisDisplay.typeLabel(crisis);
    final title = CrisisDisplay.title(crisis);
    final severity = CrisisDisplay.severity(crisis);
    final location = CrisisDisplay.location(crisis);
    final conf = CrisisDisplay.confidence(crisis).toDouble();
    final signalsCount = crisis['signals_count'] ?? crisis['signal_count'] ?? 1;
    final String lastUpdated = CrisisDisplay.lastUpdated(crisis);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: CiroColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: CiroColors.navyDark.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, -10),
            spreadRadius: -10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DDE2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CrisisIcon(
                      type: typeLabel,
                      color: CiroColors.danger,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: CiroColors.navyText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SeverityBadge(level: severity),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.mapPin,
                              size: 10,
                              color: CiroColors.greyText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$location · $signalsCount signals',
                              style: const TextStyle(
                                fontSize: 10,
                                color: CiroColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Confidence Bar
              ConfBar(value: conf.toInt()),
              const SizedBox(height: 8),

              // Timestamp
              Row(
                children: [
                  const Icon(
                    LucideIcons.clock,
                    size: 10,
                    color: CiroColors.greyText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lastUpdated.isNotEmpty
                        ? 'Last updated: $lastUpdated'
                        : 'Detected just now',
                    style: const TextStyle(
                      fontSize: 10,
                      color: CiroColors.greyText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Impact Stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CiroColors.creamBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    _StatRow(label: 'Affected pop.', value: '~42,500'),
                    SizedBox(height: 6),
                    _StatRow(label: 'Blocked', value: 'MM Alam Rd, Liberty'),
                    SizedBox(height: 6),
                    _StatRow(
                      label: 'Rescue ETA',
                      value: '12 min',
                      valueColor: CiroColors.tealPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Signals and Actions Counts
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: CiroColors.greyLightBorder,
                        border: Border.all(color: const Color(0xFFDFE6EC)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            LucideIcons.radio,
                            size: 12,
                            color: CiroColors.navyText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$signalsCount Signals',
                            style: const TextStyle(
                              fontSize: 11,
                              color: CiroColors.navyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: CiroColors.greyLightBorder,
                        border: Border.all(color: const Color(0xFFDFE6EC)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.zap,
                            size: 12,
                            color: CiroColors.navyText,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '4 Actions',
                            style: TextStyle(
                              fontSize: 11,
                              color: CiroColors.navyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: CiroColors.tealBg,
                        border: Border.all(color: CiroColors.tealBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.navigation,
                            size: 13,
                            color: CiroColors.tealDark,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Zoom to City',
                            style: TextStyle(
                              fontSize: 12,
                              color: CiroColors.tealDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TanButton(
                      fullWidth: true,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DeepDiveScreen(crisis: crisis),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Full Details'),
                          SizedBox(width: 6),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 13,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: CiroColors.greyText, fontSize: 11),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? CiroColors.navyText,
            fontSize: 11,
            fontWeight: valueColor != null
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
