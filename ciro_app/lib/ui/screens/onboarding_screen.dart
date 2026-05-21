import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme.dart';
import '../components/global_components.dart';
import 'map_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: LucideIcons.wind,
      title: 'Autonomous Crisis Intelligence',
      body:
          'CIRO detects urban crises from social signals, weather, and traffic data — before official reports arrive.',
      cta: 'Next',
    ),
    _OnboardingData(
      icon: LucideIcons.radio,
      title: 'Signal to Response in Seconds',
      body:
          'Agents analyse incoming data, detect crises, plan coordinated responses, and execute dispatch automatically.',
      cta: 'Next',
    ),
    _OnboardingData(
      icon: LucideIcons.globe,
      title: 'Built for the Globe',
      body:
          'Global crisis intelligence optimised for Pakistan. Native Roman Urdu signal processing with worldwide disaster coverage.',
      cta: 'Get Started',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CiroColors.creamBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentIndex + 1} / ${_pages.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CiroColors.greyText,
                    ),
                  ),
                  TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 13,
                        color: CiroColors.tanText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Illustration Placeholder
                        Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: CiroColors.greyBorder),
                            boxShadow: [
                              BoxShadow(
                                color: CiroColors.navyDark.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 8),
                                spreadRadius: -15,
                              ),
                            ],
                          ),
                          child: Center(
                            child: index == 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/branding/applogo.png',
                                        width: 140,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 18),
                                      const Text(
                                        'CIRO',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: CiroColors.navyText,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    page.icon,
                                    size: 80,
                                    color: CiroColors.tealPrimary.withOpacity(
                                      0.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: CiroColors.navyText,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Body
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7C8A),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots & CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: _currentIndex == index ? 24 : 6,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? CiroColors.tanText
                              : const Color(0xFFD6DDE2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTA Button
                  TanButton(
                    onPressed: _nextPage,
                    child: Text(_pages[_currentIndex].cta),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String body;
  final String cta;

  _OnboardingData({
    required this.icon,
    required this.title,
    required this.body,
    required this.cta,
  });
}
