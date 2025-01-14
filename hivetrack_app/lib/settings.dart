import 'package:flutter/material.dart';
import 'Company/CompanyNavBar.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // This will navigate to the previous page
          },
        ),
        backgroundColor: Color(0xFFFBD46D),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Section(
                title: 'Account',
                children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit profile', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.security),
                title: Text('Security', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Privacy', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
            ]),
            SizedBox(height: 16),
            Section(title: 'Actions', children: [
              ListTile(
                leading: Icon(Icons.flag),
                title: Text('Report a problem', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Add account', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out', style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black)),
                onTap: () {},
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: CompanyNavBar(
        currentIndex: 0, // Set the initial tab index
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const Section({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.brown[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
