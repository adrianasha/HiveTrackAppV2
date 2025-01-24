import 'package:flutter/material.dart';
import 'package:hivetrack_app/Agents/ScanIn.dart';
import 'package:intl/intl.dart';
import '../EssentialFunctions.dart';
import '../NavBar.dart';
import 'AgentsMapDropship.dart';
import 'ScanOut.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  _AgentDashboardState createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {
  Map<String, dynamic> userData = {};
  String todayDate = DateFormat.yMMMMd().format(DateTime.now());
  String username = "Unknown";
  int stockInCount = 10;
  int stockOutCount = 5;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentAuthUserId(), // Access widget.userId here
      builder: (context, secondSnapshot) {
        if (secondSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (secondSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${secondSnapshot.error}')),
          );
        } else if (!secondSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('No verified user data found.')),
          );
        } else {
          final userId = secondSnapshot.data;

          return FutureBuilder<Map<String, dynamic>>(
            future: getUserDataWithParentName(userId!), // Access widget.userId here
            builder: (context, secondSnapshot) {
              if (secondSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (secondSnapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${secondSnapshot.error}')),
                );
              } else if (!secondSnapshot.hasData) {
                return const Scaffold(
                  body: Center(child: Text('No verified user data found.')),
                );
              } else {
                final Data = secondSnapshot.data;
                userData = Data!["user_data"];
                username = userData["name"] ?? "Unknown";
                return buildDashboard(context);
              }
            },
          );
        }
      },
    );
  }

  void updateCounts({int? newStockIn, int? newStockOut}) {
    setState(() {
      if (newStockIn != null) stockInCount = newStockIn;
      if (newStockOut != null) stockOutCount = newStockOut;
    });
  }

  Widget buildDashboard(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFBD46D),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // const CircleAvatar(
            //   radius: 30,
            //   backgroundColor: Colors.grey, // Placeholder for the profile picture
            // ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello,",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 500,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          todayDate,
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "$stockInCount",
                              style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Stock In",
                              style: TextStyle(fontFamily: 'Roboto', fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "$stockOutCount",
                              style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Stock Out",
                              style: TextStyle(fontFamily: 'Roboto', fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanIn(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.rss_feed, color: Colors.black),
                    label: const Text(
                      "Stock In Scan",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200],
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanOut(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.rss_feed, color: Colors.black),
                    label: const Text(
                      "Stock Out Scan",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200],
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentsMapDropship(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 440,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),
                          Image.asset(
                            'assets/flyingBeee.png',
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Honey Dropship Agents",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        role: 'Agent',
      ),
    );
  }
}
