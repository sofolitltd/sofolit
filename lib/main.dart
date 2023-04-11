import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sofolit/auth/login.dart';
import 'package:sofolit/screens/splash.dart';
import 'package:url_strategy/url_strategy.dart';

import '/screens/dashboard.dart';
import '/ui/course_details.dart';
import '/ui/courses.dart';
import '/ui/profile.dart';
import 'firebase_options.dart';
import 'ui/resource.dart';

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
    return MaterialApp.router(
      title: 'Sofol IT',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent.shade200,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.deepPurpleAccent.shade200,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
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
      routerConfig: _router,
    );
  }
}

const ValueKey<String> _scaffoldKey = ValueKey<String>('App scaffold');

GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/splash'),
    GoRoute(path: '/dashboard', redirect: (_, __) => '/dashboard/courses'),

    //
    GoRoute(path: '/splash', builder: (_, __) => const Splash()),
    GoRoute(path: '/login', builder: (_, __) => const Login()),

    //
    GoRoute(
      path: '/dashboard/courses',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: _scaffoldKey,
        child: const Dashboard(
          selectedTab: ScaffoldTab.courses,
          child: Courses(),
        ),
      ),
    ),
    GoRoute(
      path: '/dashboard/courses/figma',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: ValueKey<String>(
            state.location + DateTime.now().millisecondsSinceEpoch.toString()),
        child: const Dashboard(
          selectedTab: ScaffoldTab.courses,
          child: Figma(),
        ),
      ),
    ),
    GoRoute(
      path: '/dashboard/resources',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: _scaffoldKey,
        child: const Dashboard(
          selectedTab: ScaffoldTab.resources,
          child: Resource(),
        ),
      ),
    ),
    GoRoute(
      path: '/dashboard/profile',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: _scaffoldKey,
        child: const Dashboard(
          selectedTab: ScaffoldTab.profile,
          child: Profile(),
        ),
      ),
    ),
  ],
);

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
