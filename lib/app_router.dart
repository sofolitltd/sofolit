import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sofolit/dashboard/course_screen_user.dart';

import '/dashboard/dashboard.dart';
import 'components/app_drawer.dart';
import 'components/app_header.dart';
import 'course/course_details.dart';
import 'course/course_screen.dart';
import 'course/payment_screen.dart';
import 'home/home_screen.dart';

bool isAdminLoggedIn = false;

// AppRouter configuration
final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // main
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          drawer:
              MediaQuery.of(context).size.width < 600
                  ? const AppDrawer()
                  : null,
          body: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: SelectionArea(child: child),
              ), // This is the child route
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/', // Initial route for HomeScreen
          pageBuilder: (context, state) {
            getTitle(context, 'Sofol IT | Success begins here');
            return const NoTransitionPage(
              child: HomeScreen(),
            ); // HomeScreen as initial page
          },
        ),
        GoRoute(
          path: '/courses',
          pageBuilder: (context, state) {
            getTitle(context, 'Courses | Sofol IT');
            return const NoTransitionPage(child: CourseScreen());
          },
          routes: [
            GoRoute(
              path: ':slug', // Route with slug as a parameter
              pageBuilder: (context, state) {
                final String slug = state.pathParameters['slug']!;
                String title = slug.replaceAll('-', ' ');
                //capitalize each first letter
                title = title
                    .split(' ')
                    .map((word) {
                      return word.isNotEmpty
                          ? '${word[0].toUpperCase()}${word.substring(1)}'
                          : word;
                    })
                    .join(' ');

                getTitle(context, '$title | Sofol IT');
                return NoTransitionPage(child: CourseDetailsScreen(slug: slug));
              },
            ),
            GoRoute(
              path: ':slug/payment',
              pageBuilder: (context, state) {
                final slug = state.pathParameters['slug'];
                final paymentID = state.uri.queryParameters['paymentID'];
                final status = state.uri.queryParameters['status'];

                return NoTransitionPage(
                  child: PaymentScreen(
                    paymentID: paymentID ?? 'Unknown Payment ID',
                    status: status ?? 'Unknown Status',
                    slug: slug ?? 'Unknown Course ID',
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),

    //
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: Row(
            children: [
              //
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 2, color: Colors.black12),
                  ),
                ),
                width: 250,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('Courses'),
                        onTap: () {
                          context.go('/dashboard/courses');
                        },
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        context.go('/');
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) {
            getTitle(context, 'Dashboard | Success begins here');
            return const NoTransitionPage(
              child: DashboardScreen(),
            ); // HomeScreen as initial page
          },
          routes: [
            GoRoute(
              path: 'courses',
              pageBuilder: (context, state) {
                getTitle(context, 'Courses | Sofol IT');
                return const NoTransitionPage(child: CourseScreenUser());
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

// Function to set application title in app switcher
getTitle(BuildContext context, String title) {
  return SystemChrome.setApplicationSwitcherDescription(
    ApplicationSwitcherDescription(
      label: title,
      primaryColor:
          Theme.of(context).primaryColor.toARGB32(), // This line is required
    ),
  );
}
