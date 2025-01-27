import 'package:flutter/material.dart';
import '../NavBar.dart';
import 'AgentStockInHist.dart';

class ScanIn extends StatefulWidget {
  const ScanIn({Key? key}) : super(key: key);

  @override
  State<ScanIn> createState() => _ScanInState();
}

class _ScanInState extends State<ScanIn> {
  // Track button state
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBD46D),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "Stock In Scanning",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) {
              if (value == 'History') {
                // Navigate to the History page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgentStockInHistory(), // Create a placeholder HistoryPage
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'History',
                  child: Text(
                    'History',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Image.asset(
                  'assets/box-scanner.png',
                  height: 200,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "+ 1 box",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "+ 1 box",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Scanning box...",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.7, // Adjust the value dynamically if needed
                  color: Colors.yellow[700],
                  backgroundColor: Colors.yellow[200],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Summary Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 40, right: 20), // Fine-tune left/right padding
              alignment: Alignment.centerLeft, // Ensure alignment starts from the left
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Summary",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Total box scanned: 2 Boxes",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Total items: 12 Jars",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "From: HoneyBee.Co",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isScanning = !isScanning; // Toggle the scanning state
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  isScanning ? "Done" : "Start Scanning",
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0, // Set the initial tab index for the agent
        role: 'Agent', // Pass the role to adapt the NavBar to the agent
      ),
    );
  }
}