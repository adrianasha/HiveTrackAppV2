import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:intl/intl.dart';
import '../NavBar.dart';
import 'DropshipHistory.dart';
import 'DropshipScanIn.dart';

class DropshipDashboard extends StatefulWidget {
  const DropshipDashboard({Key? key}) : super(key: key);

  @override
  _DropshipDashboardState createState() => _DropshipDashboardState();
}

class _DropshipDashboardState extends State<DropshipDashboard> {
  String username = "Loading...";
  int stockInCount = 0;
  int stockOutCount = 0;
  int availableStock = 0;
  int awaitedJars = 0;
  List<Map<String, dynamic>> activities = [];
  double progress = 1; // Example progress, you can dynamically adjust this
  dynamic currentUserData;

  @override
  void initState() {
    super.initState();
    fetchDropshipAgentData();
  }

  Future<void> fetchDropshipAgentData() async {
    try {
      final userId = await getCurrentAuthUserId();
      var docSnapshot = await FirebaseFirestore.instance
          .collection("Dropship_Agent")
          .doc(userId) // Replace with dynamic ID if needed
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data();
        currentUserData = data;
        setState(() {
          username = data?["name"] ?? "Unknown";
          stockInCount = data?["Inventory"]["StockInJars"] ?? 0;
          stockOutCount = data?["Inventory"]["StockOutJars"] ?? 0;
          availableStock = data?["Inventory"]["AvailableJars"] ?? 0;
          awaitedJars = data?["Inventory"]["AwaitedJars"] ?? 0;
        });
      }
    } catch (e) {
      print("Error fetching Firestore data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFBD46D),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hello,", style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black)),
                Text(username, style: const TextStyle(fontFamily: 'Roboto', fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black)),
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
              // Stock Overview Container
              Container(
                width: double.infinity,
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
                        const Text("Today", style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(formattedDate, style: const TextStyle(fontFamily: 'Roboto', fontSize: 16)),
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
                            Text("$availableStock", style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text("Available", style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Current Activities",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add your logic for completing the activity here
                            print("Activity Completed");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[100], // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Rounded corners
                            ),
                            minimumSize: const Size(70, 30),
                          ),
                          child: const Text(
                            "Complete",
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 0),
                    Text("Ordered Amounts: $awaitedJars Jars", style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: Column(
                        children: [
                          Icon(Icons.emoji_people, size: 28, color: Colors.amber),
                          SizedBox(height: 8),
                          Text('${currentUserData != null ? currentUserData["id"] : "Unknown"}', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black)),
                        ],
                      ),
                      title: Column(
                        children: [
                          Icon(Icons.local_shipping, size: 28, color: Colors.amber),
                          SizedBox(height: 8),
                          Text('Delivery', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black)),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          Icon(Icons.person_outline_outlined, size: 28, color: awaitedJars == 0 ? Colors.amber : Colors.black),
                          SizedBox(height: 8),
                          Text('You', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Horizontal Progress Bar
                    Container(
                      width: double.infinity,
                      height: 6.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                        color: Colors.amber[100], // Background color of the progress bar
                      ),
                      child: LinearProgressIndicator(
                        value: progress,  // Set the dynamic progress value here
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),  // Color of the progress
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Scan Inventory Button
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DropshipScanIn()));
                },
                child: Container(
                  width: double.infinity,
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 20),
                      Icon(Icons.qr_code_scanner, size: 40, color: Colors.black),
                      SizedBox(height: 8),
                      Text("Scan Inventory", style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stock History Button
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DropshipHistory()));
                },
                child: Container(
                  width: double.infinity,
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 20),
                      Icon(Icons.inventory_2_outlined, size: 40, color: Colors.black),
                      SizedBox(height: 8),
                      Text("Stock History", style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        role: 'Dropship_Agent',
      ),
    );
  }
}
