import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CompanyAgentManage.dart';
import 'CompanyNavBar.dart';

class CompanyDashboard extends StatelessWidget {
  const CompanyDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    String todayDate = DateFormat.yMMMMd().format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFBD46D),
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'HoneyBee .Co',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Today',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              todayDate,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildOverviewCard(
                      context,
                      icon: Icons.hive,
                      label: 'Honey Agents',
                      iconColor: Colors.orange,
                      menuItems: [
                        PopupMenuItem<String>(
                          value: 'Agent Management',
                          child: Text(
                            'Agent Management',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Agent Location',
                          child: Text(
                            'Agent Location',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildOverviewCard(
                      context,
                      icon: Icons.bar_chart,
                      label: 'Regional Sales',
                      iconColor: Colors.yellow[700],
                      menuItems: [
                        PopupMenuItem<String>(
                          value: 'Trends',
                          child: Text(
                            'Trends',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Sales Activity',
                          child: Text(
                            'Sales Activities',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CompanyNavBar(
        currentIndex: 0, // Set the initial tab index
      ),
    );
  }

  Widget _buildOverviewCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color? iconColor,
        required List<PopupMenuEntry<String>> menuItems,
      }) {
    return Container(
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: 70,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (String value) {
                  if (value == 'Agent Management') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyAgentManagement(),
                      ),
                    );
                  } else {
                    print('Selected: $value');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return menuItems;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
