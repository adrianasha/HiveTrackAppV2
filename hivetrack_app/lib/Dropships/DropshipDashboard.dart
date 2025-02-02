import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:hivetrack_app/WebSocketService.dart';
import 'package:intl/intl.dart';
import '../NavBar.dart';
import 'DropshipHistory.dart';
import 'DropshipQRScan.dart';

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
  double progress = 0.5;
  dynamic currentUserData;
  String parentUserId = "";
  bool activityCompleted = false; // Add a flag to track if the activity is completed

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

        final CompanyLiveStorage = await WebSocketService().sendMessageAndWaitForResponse({
          "type": "fetchCompanyLiveStorage",
          "cid": data!["company_id"]
        });
        final FetchParentUserId = await WebSocketService().sendMessageAndWaitForResponse({
          "type": "fetchDropShipAgentParentId",
          "uid": currentUserData!["selected_agent"]
        });
        setState(() {
          parentUserId = FetchParentUserId["ParentUserId"] ?? "Unknown";
          username = data["name"] ?? "Unknown";
          stockInCount = data["Inventory"]["StockInJars"] is List
              ? data["Inventory"]["StockInJars"].length
              : (data["Inventory"]["StockInJars"] ?? 0);
          stockOutCount = data["Inventory"]["StockOutJars"] is List
              ? data["Inventory"]["StockOutJars"].length
              : (data["Inventory"]["StockOutJars"] ?? 0);
          availableStock = data["Inventory"]["AvailableJars"] is List
              ? data["Inventory"]["AvailableJars"].length
              : (data["Inventory"]["AvailableJars"] ?? 0);

          data["Inventory"]["AwaitedJars"].forEach((rfid) async {
            if (CompanyLiveStorage["LiveStorage"] != null && CompanyLiveStorage["LiveStorage"][rfid] != null) {
              CompanyLiveStorage["LiveStorage"][rfid].forEach((key, value) {
                if (value["CanBeSold"] != null && value["CanBeSold"] == 0) {
                  awaitedJars = awaitedJars + 1;
                }
              });
            }
          });
          if (awaitedJars > 0) {
            progress = 0.5;
          } else {
            progress = 1;
          }
        });
      }
    } catch (e) {
      print("Error fetching Firestore data: $e");
    }
  }

  void markActivityCompleted() {
    setState(() {
      activityCompleted = true; // Set the activity as completed
    });
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
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                height: 220,
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
                            markActivityCompleted(); // Mark activity as completed
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
                    // Show "No activities yet" if activity is completed
                    if (activityCompleted)
                      const Text(" No activities yet", style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey))
                    else
                      Text("Ordered Amounts: $awaitedJars Jars", style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 10),
                    // Show activity icons only if activity is not completed
                    if (!activityCompleted) ...[
                      ListTile(
                        leading: Column(
                          children: [
                            Icon(Icons.emoji_people, size: 28, color: Colors.amber),
                            SizedBox(height: 6),
                            Text(parentUserId, style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black)),
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
                            SizedBox(height: 6),
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
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Scan Inventory Button
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DropshipQRScan()));
                },
                child: Container(
                  width: double.infinity,
                  height: 130,
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
                  height: 130,
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

