import 'package:flutter/material.dart';
import '../settings.dart';
import 'CompanyDashboard.dart';
import 'CompanyNotifications.dart';

class CompanyNavBar extends StatelessWidget {
  final int currentIndex;

  const CompanyNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFFFBD46D),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.normal,
      ),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.normal,
      ),
      currentIndex: currentIndex,
      onTap: (index) {
        // Navigation logic based on the selected index
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CompanyDashboard()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CompanyNotifications()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
