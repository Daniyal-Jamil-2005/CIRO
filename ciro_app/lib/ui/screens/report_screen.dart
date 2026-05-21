import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      appBar: const TopBar(title: 'Report a Crisis'),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              // What Happened
              const Text(
                'WHAT HAPPENED?',
                style: TextStyle(
                  fontSize: 10,
                  color: CiroColors.tanText,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.all(12),
                decoration: CiroTheme.cardDecoration,
                child: const Text(
                  'Gulberg main bohat paani jama ho gaya hai, MM Alam Road par traffic ruk gayi hai aur gariyan band ho rahi hain…',
                  style: TextStyle(
                    fontSize: 12,
                    color: CiroColors.navyText,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '142 / 1000',
                  style: TextStyle(fontSize: 9, color: CiroColors.greyText),
                ),
              ),
              const SizedBox(height: 16),

              // Crisis Type
              const Text(
                'CRISIS TYPE',
                style: TextStyle(
                  fontSize: 10,
                  color: CiroColors.tanText,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ['Not sure', 'Flood', 'Fire', 'Accident', 'Road', 'Heatwave'].map((t) {
                  final isSelected = t == 'Flood';
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? CiroColors.navyLight : Colors.white,
                      border: Border.all(
                        color: isSelected ? CiroColors.navyLight : CiroColors.greyBorder,
                      ),
                      borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 16),

              // Location
              const Text(
                'LOCATION',
                style: TextStyle(
                  fontSize: 10,
                  color: CiroColors.tanText,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEEF3),
                        border: Border.all(color: const Color(0xFFBCDDE5)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LucideIcons.mapPin, size: 12, color: CiroColors.tealDark),
                          SizedBox(width: 6),
                          Text('Use GPS', style: TextStyle(fontSize: 11, color: CiroColors.tealDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: CiroColors.greyBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LucideIcons.navigation, size: 12, color: CiroColors.greyDark),
                          SizedBox(width: 6),
                          Text('Pick on Map', style: TextStyle(fontSize: 11, color: CiroColors.greyDark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('MM Alam Road, Gulberg III, Lahore', style: TextStyle(fontSize: 11, color: CiroColors.navyText)),
                    SizedBox(height: 2),
                    Text('31.5204° N, 74.3587° E', style: TextStyle(fontSize: 9, color: CiroColors.greyText)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Photo
              const Text(
                'PHOTO (OPTIONAL)',
                style: TextStyle(
                  fontSize: 10,
                  color: CiroColors.tanText,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: CiroTheme.cardDecoration,
                child: Column(
                  children: const [
                    Icon(LucideIcons.camera, size: 22, color: CiroColors.tanText),
                    SizedBox(height: 4),
                    Text('Attach Photo', style: TextStyle(fontSize: 11, color: CiroColors.greyText)),
                  ],
                ),
              ),
            ],
          ),

          // Submit Button
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: TanButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(LucideIcons.send, size: 13, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Submit Signal'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(active: 'Report'),
    );
  }
}
