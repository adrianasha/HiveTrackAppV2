import 'package:flutter/material.dart';
import 'package:hivetrack_app/Agents/ScanIn.dart';
import 'package:intl/intl.dart';
import '../NavBar.dart';
import 'ScanOut.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  _AgentDashboardState createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard> {

  String todayDate = DateFormat.yMMMMd().format(DateTime.now());

  // Example state variables
  String username = "Cindercella";
  int stockInCount = 0;
  int stockOutCount = 0;
  int taskCount = 0;

  // Example method to update state (you can call this when needed)
  void updateCounts({int? newStockIn, int? newStockOut, int? newTasks}) {
    setState(() {
      if (newStockIn != null) stockInCount = newStockIn;
      if (newStockOut != null) stockOutCount = newStockOut;
      if (newTasks != null) taskCount = newTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFBD46D),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey, // Placeholder for the profile picture
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello,",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
                ),
                Text(
                  username,
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black),
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
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          todayDate,
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("$stockInCount", style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Stock In", style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("$stockOutCount", style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Stock Out", style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("$taskCount", style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Task", style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
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
                    label: const Text("Stock In Scan", style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black)),
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
                    label: const Text("Stock Out Scan", style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black)),
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
              Container(
                width: 500,
                height: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/flyingBeee.png',
                      height: 50,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Honey Dropship Agents",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_download_outlined, color: Colors.black),
                    label: const Text("Stock In", style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_upload_outlined, color: Colors.black),
                    label: const Text("Stock Out", style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 120),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0, // Set the initial tab index for the agent
        role: 'Agent', // Pass the role to adapt the NavBar to the agent
      ),
    );
  }
}
