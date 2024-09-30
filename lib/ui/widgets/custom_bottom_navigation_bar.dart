import 'package:flutter/material.dart';
import 'package:smartbreath/core/theme/app_theme.dart';  // Bu satırı ekleyin

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GNav(
      tabMargin: EdgeInsets.fromLTRB(5, 5, 0, 20),
      backgroundColor: Theme.of(context).primaryColor,
      gap: 8,
      activeColor: Theme.of(context).primaryColor,
      iconSize: 24,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      duration: Duration(milliseconds: 400),
      tabBackgroundColor: AppTheme.primaryGreen,  // Bu satırı değiştirin
      color: Theme.of(context).focusColor,
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.location_on,
          text: 'Risk Haritası',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
        ),
      ],
      selectedIndex: currentIndex,
      onTabChange: onTap,
    );
  }
}
