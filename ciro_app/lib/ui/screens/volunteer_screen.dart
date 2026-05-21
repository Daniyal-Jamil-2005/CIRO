import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../components/global_components.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7EB5C8).withOpacity(0.3),
                          border: Border.all(color: const Color(0xFF7EB5C8)),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.users, size: 16, color: CiroColors.tealDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Jennie Shrivastava',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CiroColors.navyText),
                            ),
                            Text(
                              'Rescue Volunteer · South Zone',
                              style: TextStyle(fontSize: 10, color: CiroColors.greyText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CiroColors.navyLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rescue Volunteer',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Help alert was accepted by the volunteer. Kindly be ready to go evacuated with emergency requirements.',
                        style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7), height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5FA3B8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Illustration Mock
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: _VolunteerIllustrationPainter(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Placeholder for VictimWoman
                      Container(
                        width: 120,
                        height: 160,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Icon(LucideIcons.user, size: 60, color: Colors.white)),
                      ),
                      const SizedBox(width: 16),
                      // Placeholder for VolunteerMan
                      Container(
                        width: 120,
                        height: 180,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Icon(LucideIcons.shieldAlert, size: 60, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolunteerIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF7EB5C8).withOpacity(0.5)
      ..style = PaintingStyle.fill;
      
    final path1 = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..color = const Color(0xFF5FA3B8).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.8, size.width, size.height * 0.6)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
