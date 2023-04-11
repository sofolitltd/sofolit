import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The enum for scaffold tab.
enum ScaffoldTab { courses, resources, profile }

/// The scaffold for the book store.
class Dashboard extends StatelessWidget {
  /// Creates a [Dashboard].
  const Dashboard({
    required this.selectedTab,
    required this.child,
    super.key,
  });

  /// Which tab of the scaffold to display.
  final ScaffoldTab selectedTab;

  /// The scaffold body.
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AdaptiveNavigationScaffold(
          drawerHeader: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                //
                // FlutterLogo(),

                //
                ListTile(
                  leading: const CircleAvatar(),
                  horizontalTitleGap: 16,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Welcome'),
                      Text('Md Asifuzzaman Reyad'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          selectedIndex: selectedTab.index,
          body: child,
          onDestinationSelected: (int id) {
            switch (ScaffoldTab.values[id]) {
              case ScaffoldTab.courses:
                context.go('/dashboard/courses');
                break;
              case ScaffoldTab.resources:
                context.go('/dashboard/resources');
                break;
              case ScaffoldTab.profile:
                context.go('/dashboard/profile');
                break;
            }
          },
          destinations: const <AdaptiveScaffoldDestination>[
            AdaptiveScaffoldDestination(
              title: 'Courses',
              icon: Icons.dashboard_outlined,
            ),
            AdaptiveScaffoldDestination(
              title: 'Resources',
              icon: Icons.folder_copy_outlined,
            ),
            AdaptiveScaffoldDestination(
              title: 'Profile',
              icon: Icons.person_outline,
            ),
          ],
        ),
      );
}
