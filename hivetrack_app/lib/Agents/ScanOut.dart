import 'package:flutter/material.dart';

import '../NavBar.dart';

class ScanOut extends StatefulWidget {
  const ScanOut({Key? key}) : super(key: key);

  @override
  State<ScanOut> createState() => _ScanOutState();
}

class _ScanOutState extends State<ScanOut> {
  // Track button state
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "Stock Out Scanning",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
        centerTitle: false,
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
                      "- 1 box",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "- 1 box",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Scanning box...",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54,
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

          const SizedBox(height: 30),

          // Summary Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 40, right: 20),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Summary",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Total box scanned: 2 Boxes",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Total items: 12 Jars",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "To: AG1004",
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Start Scanning / Done Button Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Toggle between scanning states
                    isScanning = !isScanning;
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
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black,
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
