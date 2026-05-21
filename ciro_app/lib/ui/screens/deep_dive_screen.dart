import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';
import '../../utils/crisis_display.dart';

class DeepDiveScreen extends StatelessWidget {
  final Map<String, dynamic> crisis;
  const DeepDiveScreen({super.key, required this.crisis});

  @override
  Widget build(BuildContext context) {
    final title = CrisisDisplay.title(crisis);
    final severity = CrisisDisplay.severity(crisis);
    final location = CrisisDisplay.location(crisis);
    final conf = CrisisDisplay.confidence(crisis).toDouble();
    final String lastUpdated = CrisisDisplay.lastUpdated(crisis);
    final String status = CrisisDisplay.status(crisis);
    final String responsePlan =
        crisis['response_plan'] ??
        crisis['agent_3_output'] ??
        'No response plan available yet.';
    final String typeLabel = CrisisDisplay.typeLabel(crisis);
    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: TopBar(
        title: 'Crisis Details',
        showBack: true,
        right: SeverityBadge(level: severity),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
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
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: CiroColors.navyText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$location · $status',
                          style: const TextStyle(
                            fontSize: 10,
                            color: CiroColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Situation Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SITUATION',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.5,
                        color: CiroColors.tanText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Confidence',
                          style: TextStyle(
                            color: CiroColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: ConfBar(value: conf.toInt()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Affected area',
                          style: TextStyle(
                            color: CiroColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '3.4 km²',
                          style: TextStyle(
                            color: CiroColors.navyText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Last updated',
                          style: TextStyle(
                            color: CiroColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          lastUpdated.isNotEmpty ? lastUpdated : 'just now',
                          style: const TextStyle(
                            color: CiroColors.navyText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Impact Analysis Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IMPACT ANALYSIS',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.5,
                        color: CiroColors.tanText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Population',
                          style: TextStyle(
                            color: CiroColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '~42,500',
                          style: TextStyle(
                            color: CiroColors.navyText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Casualty risk',
                          style: TextStyle(
                            color: CiroColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'CRITICAL',
                          style: TextStyle(
                            color: CiroColors.danger,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Economic',
                          style: TextStyle(
                            color: CiroColors.greyText,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          'PKR 8–12M/hr',
                          style: TextStyle(
                            color: CiroColors.navyText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: const [
                        CiroChip(text: 'Road'),
                        CiroChip(text: 'Drainage'),
                        CiroChip(text: 'Power'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Before / After Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BEFORE / AFTER',
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
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBE2E2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BEFORE',
                                  style: TextStyle(
                                    color: Color(0xFF8B2A2A),
                                    fontSize: 9,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Delay: ',
                                        style: TextStyle(
                                          color: CiroColors.navyText,
                                          fontSize: 11,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '45 min',
                                        style: TextStyle(
                                          color: CiroColors.danger,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Stranded: 320',
                                  style: TextStyle(
                                    color: CiroColors.navyText,
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Alerted: 0',
                                  style: TextStyle(
                                    color: CiroColors.navyText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCEEF3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AFTER',
                                  style: TextStyle(
                                    color: CiroColors.tealDark,
                                    fontSize: 9,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Delay: ',
                                        style: TextStyle(
                                          color: CiroColors.navyText,
                                          fontSize: 11,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '12 min',
                                        style: TextStyle(
                                          color: CiroColors.success,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Stranded: 4',
                                  style: TextStyle(
                                    color: CiroColors.navyText,
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Alerted: 42,500',
                                  style: TextStyle(
                                    color: CiroColors.navyText,
                                    fontSize: 11,
                                  ),
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
              const SizedBox(height: 12),

              // Agent 3 Response Plan Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.bot,
                          size: 14,
                          color: CiroColors.tealDark,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'AGENT 3: RESPONSE PLAN',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1.5,
                            color: CiroColors.tanText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      responsePlan,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CiroColors.navyText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Nav
          const BottomNav(active: 'Map'),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final String title;
  final String status;
  final String detail;
  final IconData icon;
  final String tone;

  const _ActionItem({
    required this.title,
    required this.status,
    required this.detail,
    required this.icon,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1EA),
        border: Border.all(color: const Color(0xFFE6DCCC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 12, color: CiroColors.greyDark),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: CiroColors.navyText,
                    ),
                  ),
                ],
              ),
              CiroChip(text: status, tone: tone),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(fontSize: 10, color: CiroColors.greyText),
          ),
        ],
      ),
    );
  }
}
