import 'package:flutter/material.dart';
import '../widgets/cust_bottom_navbar.dart';
import 'home_page.dart';
import 'guide/guide_main.dart';
import 'location/location.dart';
import 'profile/profile.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const GuideMainPage(),
    const LocationsPage(),
    const ProfilePage(),
  ];

  void _handleNavigationItemSelected(int navIndex) {
    setState(() {
      _currentPageIndex = navIndex > 2 ? navIndex - 1 : navIndex;
    });
  }

  void _handleRecycleButtonPressed() {
    Navigator.pushNamed(context, '/scan-item');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: _handleRecycleButtonPressed,
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(Icons.recycling, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: CustBottomNavbar(
        onItemSelected: _handleNavigationItemSelected,
        onRecycleButtonPressed: _handleRecycleButtonPressed,
        currentIndex: _currentPageIndex,
      ),
    );
  }
}
