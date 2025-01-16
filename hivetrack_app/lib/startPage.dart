import 'package:flutter/material.dart';
import 'createAccount.dart';
import 'loginPage.dart';

class Startpage extends StatefulWidget {
  @override
  StartpageState createState() => StartpageState();
}

class StartpageState extends State<Startpage> {
  String selectedRole = "Company";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // Hidden AppBar
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              Center(
                child: Text(
                  "I’m using HiveTrack as the...",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              roleTile(
                role: "Company", // Added role parameter
                icon: Icons.apartment,
                title: "Company",
                subtitle: "Monitor your sales, trends and demands.",
                isSelected: selectedRole == "Company",
                onTap: () {
                  setState(() {
                    selectedRole = "Company";
                    print("Selected Role : Company");
                  });
                },
              ),
              const SizedBox(height: 20),
              roleTile(
                role: "Agent", // Added role parameter
                icon: Icons.person,
                title: "Agent",
                subtitle: "Manage inventory automation.",
                isSelected: selectedRole == "Agent",
                onTap: () {
                  setState(() {
                    selectedRole = "Agent";
                    print("Selected Role : Agent");
                  });
                },
              ),
              const SizedBox(height: 20),
              roleTile(
                role: "Dropship Agent", // Added role parameter
                icon: Icons.groups,
                title: "Dropship Agent",
                subtitle: "Manage and sell products.",
                isSelected: selectedRole == "Dropship Agent",
                onTap: () {
                  setState(() {
                    selectedRole = "Dropship Agent";
                    print("Selected Role : Dropship Agent");
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedRole == "Company") {
                      showAccountDialog(); // Show dialog if the role is Company
                    } else if (selectedRole == "Agent") {
                      showAccountDialog();
                    } else if (selectedRole == "Dropship Agent"){
                      showAccountDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBD46D), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 153,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 17, color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void showAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Do you have an account?",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(role: selectedRole),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Yes! Log in",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAccount(role: selectedRole), // Pass the selected role
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "No, Get Started!",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget roleTile({
    required String role,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.brown.shade800 : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 17,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.amber,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
