import 'package:flutter/material.dart';
import 'package:hivetrack_app/Company/CompanyNotifications.dart';
import '../Agents/AgentDashboard.dart';
import '../Dropships/DropshipDashboard.dart';
import '../settings.dart';
import 'Company/CompanyDashboard.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final String role;

  const NavBar({
    Key? key,
    required this.currentIndex,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFBD46D),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            if (role == "Company") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyDashboard()),
              );
            } else if (role == "Agent") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgentDashboard()),
              );
            } else if (role == "Dropship_Agent") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DropshipDashboard()),
              );
            }
            break;
          case 1:
            if (role == "Company") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CompanyNotifications(role: role)),
              );
            } else if (role == "Agent") {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => AgentDashboard()),
              //);
            } else if (role == "Dropship_Agent") {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => DropshipDashboard()),
              // );
            }
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Settings(role: role),
              ),
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
