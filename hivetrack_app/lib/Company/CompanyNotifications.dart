import 'package:flutter/material.dart';
import '../NavBar.dart';
import 'CompanyAgentRequest.dart'; // Import the page to navigate to

class CompanyNotifications extends StatelessWidget {
  final String role; // Add the role parameter for the NavBar

  CompanyNotifications({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Use pop to go back to the previous page
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Agent Requests',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 16),
            RequestTile(
              name: 'Syaamil Thaqif',
              subtitle: 'is requesting to be an agent...',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyAgentRequest()),
                );
              },
            ),
            SizedBox(height: 8),
            RequestTile(
              name: 'Karena Kapur',
              subtitle: 'is requesting to be an agent...',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompanyAgentRequest()),
                );
              },
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Handle "See all" tap, you can modify this action
                print('See all requests tapped');
              },
              child: Text(
                'See all (3)...',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1, // Set the index for the Notifications tab (assuming index 1 for this example)
        role: role, // Pass the role to the reusable NavBar
      ),
    );
  }
}

class RequestTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const RequestTile({
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(name, style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap, // Use the provided onTap callback
      ),
    );
  }
}
