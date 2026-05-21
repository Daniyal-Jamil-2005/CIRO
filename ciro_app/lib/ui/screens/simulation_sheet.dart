import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme.dart';
import '../components/global_components.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_state.dart';

class SimulationSheet extends ConsumerStatefulWidget {
  const SimulationSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SimulationSheet(),
    );
  }

  @override
  ConsumerState<SimulationSheet> createState() => _SimulationSheetState();
}

class _SimulationSheetState extends ConsumerState<SimulationSheet> {
  bool _isLoading = false;

  final String _socialPollerUrl = 'https://us-central1-ciro-by-daniyal.cloudfunctions.net/social-poller';
  final String _weatherPollerUrl = 'https://us-central1-ciro-by-daniyal.cloudfunctions.net/weather-poller';

  Future<void> _triggerSimulation() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate backend processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Push dummy crisis to Riverpod
      ref.read(crisesProvider.notifier).addCrisis({
        'crisis_id': 'sim-crisis-001',
        'title': 'Flash Flood',
        'severity': 'CRITICAL',
        'status': 'ACTIVE',
        'location': 'Gulberg, Lahore',
        'lat': 31.5204,
        'lng': 74.3587,
        'confidence_score': 94.0,
        'last_updated': 'just now',
        'response_plan': '1. Evacuate low-lying areas in Gulberg.\n2. Dispatch high-capacity pumps to MM Alam Road.\n3. Reroute traffic via Canal Road.\n4. Alert local hospitals for potential waterborne diseases.',
      });

      // Push dummy tickets to Riverpod
      ref.read(ticketsProvider.notifier).addTickets([
        {
          'service': 'Traffic Police',
          'status': 'Alerted',
          'action': 'Rerouting MM Alam Road',
          'eta': '5 mins',
          'icon': 'siren',
        },
        {
          'service': 'Rescue 1122',
          'status': 'Dispatched',
          'action': 'Heavy duty pumps',
          'eta': '12 mins',
          'icon': 'flame',
        },
        {
          'service': 'Edhi Ambulance',
          'status': 'Alerted',
          'action': 'Standby nearby',
          'eta': 'N/A',
          'icon': 'heartPulse',
        }
      ]);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simulation successful! AI detected a crisis.'),
            backgroundColor: CiroColors.tealPrimary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Simulation failed: $e'),
            backgroundColor: CiroColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scen = [
      {'n': 'Lahore Flash Flood', 's': 'CRITICAL', 'd': '5 signals · ~90s', 'sel': true, 't': 'FLOOD'},
      {'n': 'Karachi Road Blockage', 's': 'HIGH', 'd': '3 signals · ~60s', 'sel': false, 't': 'ROAD_BLOCKAGE'},
      {'n': 'Islamabad Heatwave', 's': 'MEDIUM', 'd': '2 signals · ~45s', 'sel': false, 't': 'HEATWAVE'},
      {'n': 'California Wildfire', 's': 'CRITICAL', 'd': '4 signals · ~75s', 'sel': false, 't': 'FIRE'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: CiroColors.greyBorder),
        boxShadow: [
          BoxShadow(
            color: CiroColors.navyDark.withOpacity(0.2),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Demo Scenarios', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: CiroColors.navyText)),
                      Text('Pick a scripted crisis to run', style: TextStyle(fontSize: 10, color: CiroColors.greyText)),
                    ],
                  ),
                  const CiroChip(text: 'SIMULATED', tone: 'tan', icon: LucideIcons.sparkles),
                ],
              ),
              const SizedBox(height: 12),

              // Scenarios
              Column(
                children: scen.map((c) {
                  final sel = c['sel'] as bool;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFFDCEEF3) : Colors.white,
                      border: Border.all(color: sel ? CiroColors.tealBorder : CiroColors.greyBorder),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          sel ? LucideIcons.checkCircle2 : LucideIcons.circle,
                          size: 18,
                          color: sel ? CiroColors.tealPrimary : const Color(0xFFCDD5DC),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: CiroColors.greyBorder),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CrisisIcon(type: c['t'] as String, size: 14, color: CiroColors.greyDark),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    c['n'] as String,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: CiroColors.navyText),
                                  ),
                                  const SizedBox(width: 8),
                                  SeverityBadge(level: c['s'] as String),
                                ],
                              ),
                              Text(c['d'] as String, style: const TextStyle(fontSize: 10, color: CiroColors.greyText)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Button
              TanButton(
                onPressed: _isLoading ? () {} : _triggerSimulation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    else
                      const Icon(LucideIcons.sparkles, size: 13, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(_isLoading ? 'Simulating...' : 'Start Simulation'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Switch back to Live',
                  style: TextStyle(fontSize: 11, color: CiroColors.tealDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

