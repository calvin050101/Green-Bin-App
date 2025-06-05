import 'package:flutter/material.dart';

class CustBottomNavbar extends StatefulWidget {
  final ValueChanged<int> onItemSelected;
  final VoidCallback onRecycleButtonPressed;
  final int currentIndex;

  const CustBottomNavbar({
    super.key,
    required this.onItemSelected,
    required this.onRecycleButtonPressed,
    required this.currentIndex,
  });

  @override
  State<CustBottomNavbar> createState() => _CustBottomNavbarState();
}

class _CustBottomNavbarState extends State<CustBottomNavbar> {
  final Color _selectedColor = Colors.green;
  final Color _unselectedColor = Colors.black;
  final Color _barBackgroundColor = const Color(0xFFF0F0F0);

  Widget _buildNavItem({
    required IconData iconData,
    required String label,
    required int navIndex,
    required int pageIndex,
  }) {
    final bool isSelected = widget.currentIndex == pageIndex;
    final Color itemColor = isSelected ? _selectedColor : _unselectedColor;

    return GestureDetector(
      onTap: () {
        if (navIndex != 2) {
          widget.onItemSelected(navIndex);
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: itemColor, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: itemColor,
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: _barBackgroundColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            iconData: Icons.home,
            label: 'Home',
            navIndex: 0,
            pageIndex: 0,
          ),
          _buildNavItem(
            iconData: Icons.book,
            label: 'Guide',
            navIndex: 1,
            pageIndex: 1,
          ),
          const SizedBox(width: 40),
          _buildNavItem(
            iconData: Icons.location_on,
            label: 'Locations',
            navIndex: 3,
            pageIndex: 2,
          ),
          _buildNavItem(
            iconData: Icons.person,
            label: 'Profile',
            navIndex: 4,
            pageIndex: 3,
          ),
        ],
      ),
    );
  }
}
