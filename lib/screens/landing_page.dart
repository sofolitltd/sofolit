import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
