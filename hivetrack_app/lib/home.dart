import 'package:flutter/material.dart';
import 'package:hivetrack_app/Agents/AgentDashboard.dart';
import 'package:hivetrack_app/Company/CompanyDashboard.dart';
import 'package:hivetrack_app/Dropships/DropshipDashboard.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:hivetrack_app/startPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: const SplashScreen(), // Start with the SplashScreen
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigateToDashboard(BuildContext context, String parentName) {
    Widget dashboard;

    if (parentName == 'Company') {
      dashboard = const CompanyDashboard();
    } else if (parentName == 'Agent') {
      dashboard = const AgentDashboard();
    } else if (parentName == 'Dropship_Agent') {
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
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Map<String, dynamic> UserData = await getUserDataWithParentName(user.uid);
          navigateToDashboard(context, UserData['parent_name']);
        } else {
          navigateToDashboard(context, ""); // Navigate to Startpage
        }
      } catch (e) {
        print("Error: $e");
        navigateToDashboard(context, ""); // Navigate to Startpage
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