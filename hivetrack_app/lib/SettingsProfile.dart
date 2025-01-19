import 'package:flutter/material.dart';

class SettingsProfile extends StatelessWidget {
  final String role; // 'Company', 'Agent', or 'Dropship Agent'

  SettingsProfile({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Company Name (Shown for all roles)
            TextFormField(
              initialValue: "HoneyBee .Co",
              decoration: const InputDecoration(labelText: 'Company Name'),
              readOnly: true,
            ),
            // Company ID (Shown for all roles)
            TextFormField(
              initialValue: "HBC12345",
              decoration: const InputDecoration(labelText: 'Company ID'),
              readOnly: true,
            ),
            // Agent Name (Shown for Agent and Dropship Agent roles)
            if (role == 'Agent' || role == 'Dropship_Agent')
              TextFormField(
                initialValue: role == 'Agent' ? "Syaamil Thaqif Bin Sha" : "Syaamil Thaqif Bin Sha",
                decoration: const InputDecoration(labelText: "Agent's Name"),
                readOnly: true,
              ),
            // Agent ID (Shown for Agent and Dropship Agent roles)
            if (role == 'Agent' || role == 'Dropship_Agent')
              TextFormField(
                initialValue: role == 'Agent' ? "AG1001" : "AG1001",
                decoration: const InputDecoration(labelText: "Agent ID"),
                readOnly: true,
              ),
            // Dropshipper's Name (Shown only for Dropship Agent role)
            if (role == 'Dropship_Agent')
              TextFormField(
                initialValue: "Yusuf Bin Aiman",
                decoration: const InputDecoration(labelText: "Dropshipper's Name"),
                readOnly: true,
              ),
            // Dropshipper ID (Shown only for Dropship Agent role)
            if (role == 'Dropship_Agent')
              TextFormField(
                initialValue: "DSAG1001",
                decoration: const InputDecoration(labelText: "Dropshipper's ID"),
                readOnly: true,
              ),
            // Email (Shown for all roles)
            TextFormField(
              initialValue: role == 'Company'
                  ? "beefac@gmail.com"
                  : role == 'Agent'
                  ? "toqip@gmail.com"
                  : "yusuf@gmail.com",
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password (Shown for all roles)
            TextFormField(
              initialValue: "**********",
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // Address (Shown for all roles)
            TextFormField(
              initialValue: role == 'Company'
                  ? "9, Jalan Perusahaan 1, Taman Industri Selesa Jaya, 43300 Balakong, Selangor"
                  : "35, Jalan Damai Budi 6, Alam Damai, 56000 Cheras, Kuala Lumpur",
              decoration: const InputDecoration(labelText: 'Address'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Settings tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
