import 'package:flutter/material.dart';
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
  String username = "Cindercella";
  int stockInCount = 12;
  int stockOutCount = 5;
  int availableStock = 12;

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
                const Text(
                  "Hello,",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
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
                        const Text(
                          "Today",
                          style: TextStyle(
                              fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
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
                              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
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
                              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "$availableStock",
                              style: const TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Available",
                              style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                            ),
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
                    const Text(
                      "Current Activity",
                      style: TextStyle(
                          fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Ordered Amount : 6 jars",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Status : Preparing Shipping...",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 15),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: const [
                            Icon(Icons.person, size: 40, color: Colors.black),
                            SizedBox(height: 4),
                            Text("AG1029", style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.local_shipping, size: 40, color: Colors.black),
                            SizedBox(height: 4),
                            Text("Out for delivery", style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(Icons.person_outline_outlined, size: 40, color: Colors.black),
                            SizedBox(height: 4),
                            Text("You", style: TextStyle(fontFamily: 'Roboto', fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DropshipScanIn()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(Icons.qr_code_scanner, size: 40, color: Colors.black),
                      const SizedBox(height: 8),
                      const Text("Scan Inventory",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DropshipHistory()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.black),
                      const SizedBox(height: 8),
                      const Text("Stock History",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16)),
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
