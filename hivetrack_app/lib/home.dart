import 'package:flutter/material.dart';
import 'package:hivetrack_app/Agents/AgentDashboard.dart';
import 'package:hivetrack_app/Company/CompanyDashboard.dart';
import 'package:hivetrack_app/Dropships/DropshipDashboard.dart';
import 'package:hivetrack_app/startPage.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiveTrack',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Raleway',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigateToDashboard(BuildContext context, String parentName, Map<String, dynamic> userData) {
    Widget dashboard;

    if (parentName == 'Company') {
      dashboard = const CompanyDashboard();
    } else if (parentName == 'Agent' && userData["verified"] == true) {
      dashboard = const AgentDashboard();
    } else if (parentName == 'Dropship_Agent' && userData["verified"] == true) {
      dashboard = DropshipDashboard();
    } else {
      dashboard = Startpage();
    }

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dashboard),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      try {
        String? userID = await getCurrentAuthUserId();
        if (userID != null) {
          Map<String, dynamic> UserData = await getUserDataWithParentName(userID);
          navigateToDashboard(context, UserData['parent_name'], UserData["user_data"]);
        } else {
          navigateToDashboard(context, "", {}); // Navigate to Startpage
        }
      } catch (e) {
        print("Error: $e");
        navigateToDashboard(context, "", {}); // Navigate to Startpage
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logogo.png', width: 300, height: 300),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}