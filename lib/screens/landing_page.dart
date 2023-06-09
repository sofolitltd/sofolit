import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '/screens/more/more.dart';
import 'dashboard/dashboard.dart';
import 'free.dart';
import 'home/home.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 1;
  final _controller = SidebarXController(selectedIndex: 1, extended: true);

  //
  static const List _screens = [
    Home(),
    Dashboard(),
    Free(),
    More(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: !isSmallScreen
          ? Row(
              children: [
                //
                AppSidebarX(controller: _controller),
                //
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            )
          : _screens.elementAt(_selectedIndex),
      bottomNavigationBar: !isSmallScreen
          ? null
          : BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fitbit_rounded),
                  label: 'Free',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_outlined),
                  label: 'More',
                ),
              ],
              currentIndex: _selectedIndex,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: Colors.deepPurpleAccent,
              selectedFontSize: 13,
              unselectedFontSize: 13,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
            ),
    );
  }
}

class AppSidebarX extends StatelessWidget {
  const AppSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: SidebarX(
        controller: _controller,
        theme: SidebarXTheme(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          textStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
          hoverColor: Colors.grey,
          selectedTextStyle: const TextStyle(color: Colors.black),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: actionColor.withOpacity(0.37),
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black.withOpacity(0.7),
            size: 20,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.deepPurpleAccent,
            size: 20,
          ),
        ),
        extendedTheme: SidebarXTheme(
          width: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: canvasColor,
            color: Theme.of(context).cardColor,
          ),
        ),
        footerDivider: const Divider(),
        headerBuilder: (context, extended) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 4 : 20),
              child: Image.asset(
                extended
                    ? 'assets/logo/logo_black.png'
                    : 'assets/logo/logo_small.png',
              ),
            ),
          );
        },
        items: [
          SidebarXItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {
              debugPrint('Home');
            },
          ),
          const SidebarXItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
          ),
          const SidebarXItem(
            icon: Icons.fitbit_rounded,
            label: 'Free',
          ),
          const SidebarXItem(
            icon: Icons.more_outlined,
            label: 'More',
          ),
        ],
      ),
    );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return const Home();
          case 2:
            return const Free();
          case 3:
            return const More();
          default:
            return const Dashboard();
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'Search';
    case 2:
      return 'People';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}
