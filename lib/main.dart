import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sofolit/screens/splash.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //remove #
  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sofol IT',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade200,
        primaryColor: Colors.deepPurpleAccent.shade200,
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.hindSiliguri().fontFamily,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.deepPurpleAccent.shade200,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 48),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(100, 48),
          ),
        ),
      ),
      home: const Splash(),
    );
  }
}

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
