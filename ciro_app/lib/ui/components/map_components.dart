import 'package:flutter/material.dart';
import '../../theme.dart';
import 'global_components.dart';

class MapBg extends StatelessWidget {
  const MapBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3EDF2),
      child: CustomPaint(
        painter: _MapPainter(),
        child: Container(),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid
    final gridPaint = Paint()
      ..color = const Color(0xFFCDDDE4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (double i = 0; i < size.width; i += 32) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 32) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Land patches (approximate from React mock)
    final landPaint = Paint()
      ..color = const Color(0xFFCFE1D6).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(30, 160)
      ..quadraticBezierTo(80, 140, 130, 170)
      ..quadraticBezierTo(170, 200, 150, 250)
      ..quadraticBezierTo(120, 280, 70, 260)
      ..quadraticBezierTo(20, 230, 30, 160)
      ..close();
    canvas.drawPath(path1, landPaint);

    // River
    final riverPaint = Paint()
      ..color = const Color(0xFF9BC6D2).withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final riverPath = Path()
      ..moveTo(0, 440)
      ..quadraticBezierTo(80, 420, 160, 450)
      ..quadraticBezierTo(240, 480, size.width, 460);
    canvas.drawPath(riverPath, riverPaint);

    // Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawLine(const Offset(20, 300), const Offset(300, 290), roadPaint);
    canvas.drawLine(const Offset(160, 80), const Offset(150, 560), roadPaint);

    final trafficPaint = Paint()
      ..color = CiroColors.danger.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(20, 300), const Offset(300, 290), trafficPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Pin extends StatelessWidget {
  final double x;
  final double y;
  final String level;
  final String type;
  final VoidCallback? onTap;

  const Pin({
    super.key,
    required this.x,
    required this.y,
    required this.level,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (level) {
      case 'CRITICAL':
        color = CiroColors.danger;
        break;
      case 'HIGH':
        color = const Color(0xFFE07A3C);
        break;
      case 'MEDIUM':
        color = const Color(0xFFD4A93C);
        break;
      case 'RESOLVING':
        color = CiroColors.tealPrimary;
        break;
      default:
        color = CiroColors.greyDark;
    }

    return Positioned(
      left: MediaQuery.of(context).size.width * (x / 100) - 16,
      top: MediaQuery.of(context).size.height * (y / 100) - 40,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
          if (level == 'CRITICAL')
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                // Add flutter_animate here later
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: CrisisIcon(type: type, size: 14, color: Colors.white),
                ),
              ),
              CustomPaint(
                size: const Size(10, 7),
                painter: _TrianglePainter(color),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
