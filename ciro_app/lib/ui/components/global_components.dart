import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../../utils/crisis_display.dart';

// --- Badges & Chips ---

class SeverityBadge extends StatelessWidget {
  final String level;
  const SeverityBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (level.toUpperCase()) {
      case 'CRITICAL':
        bgColor = CiroColors.danger;
        break;
      case 'HIGH':
        bgColor = const Color(0xFFE07A3C);
        break;
      case 'MEDIUM':
        bgColor = const Color(0xFFD4A93C);
        break;
      case 'RESOLVING':
        bgColor = CiroColors.tealPrimary;
        break;
      case 'RESOLVED':
        bgColor = CiroColors.success;
        break;
      default:
        bgColor = CiroColors.greyDark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          letterSpacing: 1.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CiroChip extends StatelessWidget {
  final String text;
  final String tone;
  final IconData? icon;

  const CiroChip({
    super.key,
    required this.text,
    this.tone = 'default',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor, textColor, borderColor;

    switch (tone) {
      case 'teal':
        bgColor = CiroColors.tealBg;
        textColor = CiroColors.tealDark;
        borderColor = CiroColors.tealBorder;
        break;
      case 'tan':
        bgColor = const Color(0xFFF4E9D4);
        textColor = const Color(0xFF86683A);
        borderColor = const Color(0xFFE6D4AD);
        break;
      case 'navy':
        bgColor = CiroColors.navyLight;
        textColor = Colors.white;
        borderColor = const Color(0xFF27425A);
        break;
      case 'red':
        bgColor = const Color(0xFFFBE2E2);
        textColor = const Color(0xFF8B2A2A);
        borderColor = const Color(0xFFF1C5C5);
        break;
      default:
        bgColor = CiroColors.greyLightBorder;
        textColor = CiroColors.greyDark;
        borderColor = const Color(0xFFDFE6EC);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 9,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Icons & Indicators ---

class CrisisIcon extends StatelessWidget {
  final String type;
  final double size;
  final Color? color;

  const CrisisIcon({super.key, required this.type, this.size = 18, this.color});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (CrisisDisplay.typeCode({'type': type})) {
      case 'FLOOD':
        iconData = LucideIcons.droplets;
        break;
      case 'FIRE':
        iconData = LucideIcons.flame;
        break;
      case 'STORM':
        iconData = LucideIcons.wind;
        break;
      case 'HEATWAVE':
        iconData = LucideIcons.sun;
        break;
      case 'ROAD_BLOCKAGE':
        iconData = LucideIcons.hammer; // Approximate for Construction
        break;
      case 'EARTHQUAKE':
        iconData = LucideIcons.activity;
        break;
      case 'LANDSLIDE':
        iconData = LucideIcons.mountain;
        break;
      case 'INFRASTRUCTURE_FAILURE':
        iconData = LucideIcons.zap;
        break;
      case 'ACCIDENT':
        iconData = LucideIcons.alertTriangle;
        break;
      default:
        iconData = LucideIcons.alertCircle;
    }

    return Icon(iconData, size: size, color: color);
  }
}

class ConfBar extends StatelessWidget {
  final int value;
  const ConfBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100).toDouble();
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: 6,
                decoration: BoxDecoration(
                  color: CiroColors.greyLightBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: clamped / 100,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  CiroColors.tealLight,
                                  Color(0xFFD4A93C),
                                  CiroColors.danger,
                                ],
                                stops: [0.0, 0.6, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '${clamped.toInt()}%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 10,
              color: CiroColors.navyText,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class SourceDots extends StatelessWidget {
  const SourceDots({super.key});

  @override
  Widget build(BuildContext context) {
    final states = ['on', 'on', 'on', 'stale', 'on', 'err'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: states.map((s) {
        Color c;
        if (s == 'on') {
          c = CiroColors.tealPrimary;
        } else if (s == 'stale') {
          c = const Color(0xFFD4A93C);
        } else {
          c = CiroColors.danger;
        }
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            boxShadow: s == 'on'
                ? [
                    BoxShadow(
                      color: CiroColors.tealPrimary.withOpacity(0.6),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        );
      }).toList(),
    );
  }
}

// --- Buttons ---

class TanButton extends StatelessWidget {
  final Widget child;
  final bool fullWidth;
  final VoidCallback? onPressed;

  const TanButton({
    super.key,
    required this.child,
    this.fullWidth = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [CiroColors.tanGradientStart, CiroColors.tanGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: CiroColors.tanGradientEnd.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            alignment: fullWidth ? Alignment.center : null,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

// --- Navigation ---

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? right;
  final VoidCallback? onBackPressed;

  const TopBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.right,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(LucideIcons.chevronLeft, size: 18),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      leadingWidth: showBack ? 48 : 0,
      titleSpacing: showBack ? 0 : 16,
      title: Align(alignment: Alignment.centerLeft, child: Text(title)),
      actions: [
        if (right != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: right!),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      LucideIcons.bell,
                      size: 17,
                      color: CiroColors.greyDark,
                    ),
                    Positioned(
                      right: 0,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: CiroColors.danger,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: const Text(
                          '4',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                const Icon(
                  LucideIcons.settings,
                  size: 17,
                  color: CiroColors.greyDark,
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BottomNav extends StatelessWidget {
  final String active;
  const BottomNav({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CiroColors.greyBorder),
          boxShadow: [
            BoxShadow(
              color: CiroColors.navyDark.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -12,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              label: 'Map',
              icon: LucideIcons.map,
              isActive: active == 'Map',
              onTap: () {
                if (active != 'Map')
                  Navigator.pushReplacementNamed(context, '/map');
              },
            ),
            _NavItem(
              label: 'Feed',
              icon: LucideIcons.radio,
              isActive: active == 'Feed',
              onTap: () {
                if (active != 'Feed')
                  Navigator.pushReplacementNamed(context, '/feed');
              },
            ),
            _NavItem(
              label: 'Report',
              icon: LucideIcons.alertTriangle,
              isActive: active == 'Report',
              onTap: () {
                if (active != 'Report')
                  Navigator.pushReplacementNamed(context, '/report');
              },
            ),
            _NavItem(
              label: 'Dispatch',
              icon: LucideIcons.radioTower,
              isActive: active == 'Dispatch',
              onTap: () {
                if (active != 'Dispatch')
                  Navigator.pushReplacementNamed(context, '/dispatch');
              },
            ),
            _NavItem(
              label: 'Analytics',
              icon: LucideIcons.barChart2,
              isActive: active == 'Analytics',
              onTap: () {
                if (active != 'Analytics')
                  Navigator.pushReplacementNamed(context, '/analytics');
              },
            ),
            _NavItem(
              label: 'More',
              icon: LucideIcons.grid,
              isActive: active == 'More',
              onTap: () {
                if (active != 'More')
                  Navigator.pushReplacementNamed(context, '/more');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? CiroColors.tealBg : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? CiroColors.tealDark : CiroColors.greyText,
            ),
            if (isActive) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: CiroColors.tealDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
