import 'package:flutter/material.dart';
import 'package:hivetrack_app/startPage.dart';

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

  @override
  Widget build(BuildContext context) {
    // Navigate to Welcome screen after 2 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Startpage()),
      );
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

