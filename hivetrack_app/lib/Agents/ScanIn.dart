import 'package:flutter/material.dart';
import '../EssentialFunctions.dart';
import '../NavBar.dart';
import 'AgentDashboard.dart';
import 'AgentStockInHist.dart';

class ScanIn extends StatefulWidget {
  const ScanIn({Key? key}) : super(key: key);

  @override
  State<ScanIn> createState() => _ScanInState();
}

class _ScanInState extends State<ScanIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBD46D),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "Stock In Scanning",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) {
              if (value == 'History') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgentStockInHistory(),
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
                  // children: const [
                  //   Text(
                  //     "+ 1 box",
                  //     style: TextStyle(
                  //       fontFamily: 'Roboto',
                  //       fontSize: 16,
                  //       color: Colors.green,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //   SizedBox(width: 10),
                  //   Text(
                  //     "+ 1 box",
                  //     style: TextStyle(
                  //       fontFamily: 'Roboto',
                  //       fontSize: 16,
                  //       color: Colors.green,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ],
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
                  value: 0.7,
                  color: Colors.yellow[700],
                  backgroundColor: Colors.yellow[200],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Done Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SummaryDialog();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
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
        currentIndex: 0,
        role: 'Agent',
      ),
    );
  }
}

class SummaryDialog extends StatelessWidget {
  const SummaryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Summary",
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // First FutureBuilder for user ID
          FutureBuilder<String?>(
            future: getCurrentAuthUserId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No verified user data found.');
              } else {
                final userId = snapshot.data!;
                return UserSummary(userId: userId);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgentDashboard(),
              ),
            );
          },
          child: const Text(
            "Close",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class UserSummary extends StatelessWidget {
  final String userId;

  const UserSummary({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserDataWithParentName(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No verified user data found.');
        } else {
          final data = snapshot.data!;
          final inventoryData = data["user_data"]["Inventory"];
          final boxCount = inventoryData["StockInBox"]?.length ?? 0;
          final jarCount = boxCount * 6;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total box scanned: $boxCount Boxes",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                "Total items: $jarCount Jars",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                "From: HoneyBee.Co",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black54),
              ),
            ],
          );
        }
      },
    );
  }
}
