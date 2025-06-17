import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/pages/scan_item/scan_item_main.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/cust_bottom_navbar.dart';
import 'home_page.dart';
import 'guide/guide_main.dart';
import 'location/location_page.dart';
import 'profile/profile.dart';

class MainWrapperScreen extends ConsumerStatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  ConsumerState<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends ConsumerState<MainWrapperScreen> {
  int _currentPageIndex = 0;

  Widget _getPage(AsyncValue<UserModel?> userAsyncValue) {
    final List<Widget> pages = [
      HomePage(userAsyncValue: userAsyncValue),
      const GuideMainPage(),
      const LocationsPage(),
      ProfilePage(userAsyncValue: userAsyncValue),
    ];

    return pages[_currentPageIndex];
  }

  void _handleNavigationItemSelected(int navIndex) {
    setState(() {
      _currentPageIndex = navIndex > 2 ? navIndex - 1 : navIndex;
    });
  }

  void _handleRecycleButtonPressed() {
    Navigator.pushNamed(context, ScanItemMainPage.routeName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return Scaffold(
      body: _getPage(userAsyncValue),

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
