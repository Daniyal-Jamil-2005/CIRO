import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';

class TraceScreen extends StatelessWidget {
  const TraceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final agents = [
      {'n': 'Agent 1', 't': 'Signal Extraction', 'st': 'SUCCESS', 'dur': '412ms'},
      {'n': 'Agent 2', 't': 'Detection & Scoring', 'st': 'SUCCESS', 'dur': '881ms'},
      {'n': 'Agent 3', 't': 'Response Planning', 'st': 'SUCCESS', 'dur': '1.2s'},
      {'n': 'Agent 4', 't': 'Action Execution', 'st': 'SUCCESS', 'dur': '1.4s'},
    ];

    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'Agent Trace'),
      body: Column(
        children: [
          // Header Card
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: CiroTheme.cardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.cpu, size: 14, color: CiroColors.tealDark),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'CRISIS',
                            style: TextStyle(
                              fontSize: 9,
                              color: CiroColors.greyText,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Flash Flood · Lahore · 14:22',
                            style: TextStyle(
                              fontSize: 12,
                              color: CiroColors.navyText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.chevronDown, size: 14, color: CiroColors.greyText),
                ],
              ),
            ),
          ),

          // Agents List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final a = agents[index];
                final isRunning = a['st'] == 'RUNNING';
                final isLast = index == agents.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline indicator
                      SizedBox(
                        width: 32,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            if (!isLast)
                              Positioned(
                                top: 24,
                                bottom: 0,
                                child: Container(
                                  width: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        CiroColors.tealPrimary,
                                        CiroColors.tealPrimary.withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: isRunning ? Colors.white : CiroColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isRunning ? CiroColors.tealPrimary : CiroColors.success,
                                  width: 2,
                                ),
                              ),
                              child: isRunning
                                  ? const Center(
                                      child: SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(CiroColors.tealPrimary),
                                        ),
                                      ),
                                    )
                                  : const Icon(LucideIcons.check, size: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Card
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: CiroTheme.cardDecoration,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a['t']!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: CiroColors.navyText,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${a['n']} · Gemini 1.5 Pro',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: CiroColors.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    CiroChip(text: a['st']!, tone: isRunning ? 'teal' : 'default'),
                                  ],
                                ),
                                if (index == 1) ...[
                                  const SizedBox(height: 12),
                                  const Text(
                                    '"7 signals clustered around Gulberg. Confidence 94 (CRITICAL)."',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: CiroColors.greyDark,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _ScoreBox(label: 'Base', score: 65),
                                      const SizedBox(width: 4),
                                      _ScoreBox(label: 'Geo', score: 22),
                                      const SizedBox(width: 4),
                                      _ScoreBox(label: 'Time', score: 18),
                                      const SizedBox(width: 4),
                                      _ScoreBox(label: 'Div', score: 18),
                                      const SizedBox(width: 4),
                                      _ScoreBox(label: 'Media', score: 15),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(LucideIcons.clock, size: 10, color: CiroColors.greyText),
                                        const SizedBox(width: 4),
                                        Text(
                                          a['dur']!,
                                          style: const TextStyle(fontSize: 10, color: CiroColors.greyText),
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      children: [
                                        Icon(LucideIcons.eye, size: 10, color: CiroColors.tealDark),
                                        SizedBox(width: 4),
                                        Text(
                                          'Show JSON',
                                          style: TextStyle(fontSize: 10, color: CiroColors.tealDark),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Timeline overview
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: CiroTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TIMELINE',
                    style: TextStyle(
                      fontSize: 9,
                      color: CiroColors.tanText,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(flex: 10, child: _TimelineBar()),
                      const SizedBox(width: 2),
                      Expanded(flex: 12, child: _TimelineBar()),
                      const SizedBox(width: 2),
                      Expanded(flex: 18, child: _TimelineBar()),
                      const SizedBox(width: 2),
                      Expanded(flex: 15, child: _TimelineBar()),
                      const SizedBox(width: 2),
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCEEF3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0s', style: TextStyle(fontSize: 9, color: CiroColors.greyText)),
                      Text('Total 2.7s', style: TextStyle(fontSize: 9, color: CiroColors.greyText)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: 'More'),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreBox({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F1EA),
          border: Border.all(color: const Color(0xFFE6DCCC)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              score.toString(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: CiroColors.tanText,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 8,
                color: CiroColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CiroColors.tealPrimary, CiroColors.tealDark],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
