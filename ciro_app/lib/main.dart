import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/map_screen.dart';
import 'ui/screens/feed_screen.dart';
import 'ui/screens/trace_screen.dart';
import 'ui/screens/more_screen.dart';
import 'ui/screens/dispatch_screen.dart';
import 'ui/screens/report_screen.dart';
import 'ui/screens/analytics_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: CiroApp()));
}

class CiroApp extends StatelessWidget {
  const CiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIRO',
      theme: CiroTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const StartupGate(),
      routes: {
        '/map': (context) => const MapScreen(),
        '/feed': (context) => const FeedScreen(),
        '/trace': (context) => const TraceScreen(),
        '/more': (context) => const MoreScreen(),
        '/dispatch': (context) => const DispatchScreen(),
        '/report': (context) => const ReportScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
      },
    );
  }
}

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  late final Future<bool> _shouldShowOnboarding = _loadFlag();

  Future<bool> _loadFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('has_seen_onboarding') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _shouldShowOnboarding,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data == true
            ? const OnboardingScreen()
            : const MapScreen();
      },
    );
  }
}
