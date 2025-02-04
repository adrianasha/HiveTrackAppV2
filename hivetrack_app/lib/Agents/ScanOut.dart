import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../EssentialFunctions.dart';
import '../NavBar.dart';
import '../WebSocketService.dart';
import 'AgentDashboard.dart';
import 'AgentStockOutHist.dart';

class ScanOut extends StatefulWidget {
  const ScanOut({Key? key}) : super(key: key);

  @override
  State<ScanOut> createState() => _ScanOutState();
}

class _ScanOutState extends State<ScanOut> {
  bool isScanning = false;
  String? selectedAgent;
  bool showWarningText = false; // Flag to show warning text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBD46D),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "Stock Out Scanning",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'History') {
                // Navigate to History page or perform desired action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgentStockOutHistory(),
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
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "- 1 box",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "- 1 box",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Text asking user to choose dropship agent
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Please choose dropship agent",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Dropdown for choosing dropship agent
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FutureBuilder<String?>(
              future: getCurrentAuthUserId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No requests found'));
                }

                final uid = snapshot.data!;
                return FutureBuilder<Map<String, dynamic>>(
                  future: getUserDataWithParentName(uid),
                  builder: (context, secondSnapshot) {
                    if (secondSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (secondSnapshot.hasError) {
                      return Center(child: Text('Error: ${secondSnapshot.error}'));
                    }

                    if (!secondSnapshot.hasData || secondSnapshot.data!.isEmpty) {
                      return const Center(child: Text('No requests found'));
                    }

                    final userData = secondSnapshot.data;
                    return FutureBuilder<Map<String, dynamic>>(
                      future: getAllVerifiedUsersByCID(userData?["user_data"]["company_id"], 1),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No requests found'));
                        }

                        final verifiedUserData = snapshot.data;
                        return DropdownButtonFormField<String>(
                          value: selectedAgent,
                          hint: const Text(
                            'Select Agent',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              selectedAgent = newValue;
                              showWarningText = false; // Reset warning when agent is selected
                            });
                          },
                          items: verifiedUserData!.entries.where((entry) {
                            return userData?["user_data"]["covered_agent"] != null && userData?["user_data"]["covered_agent"].contains(entry.key);
                          }).map((entry) {
                            final agentName = entry.value['name'] ?? "Uknown";
                            final agentId = entry.value['id'] ?? "Uknown";
                            return DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text("$agentName | $agentId", style: const TextStyle(fontFamily: 'Roboto')),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // Show warning text if needed
          if (showWarningText)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Please choose Dropship Agent first",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.red, // Red text color
                ),
              ),
            ),

          // Start Scanning / Done Button Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedAgent == null) {
                    setState(() {
                      showWarningText = true; // Show warning if no agent is selected
                    });
                    return; // Exit early if no agent is selected
                  }

                  // If agent is selected, proceed with the existing logic
                  final dropship_docRef = FirebaseFirestore.instance
                      .collection("Dropship_Agent")
                      .doc(selectedAgent);

                  final userId = await getCurrentAuthUserId();
                  final agent_docRef = FirebaseFirestore.instance
                      .collection("Agent")
                      .doc(userId);

                  final agentSnapshot = await agent_docRef.get();

                  if (agentSnapshot.exists) {
                    final fullAgentData = agentSnapshot.data();
                    dynamic agentData = fullAgentData?['Inventory'];
                    int jars = agentData["StockOutBox"].length ?? 0;

                    await dropship_docRef.update({
                      'Inventory.AwaitedJars': agentData["StockOutBox"]
                    });

                    final dropshipData = (await dropship_docRef.get()).data();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SummaryDialog(tagId: dropshipData?["id"], totalBoxes: jars);
                      },
                    );
                  }
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
                    color: Colors.black,
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

class SummaryDialog extends StatelessWidget {
  final String tagId;
  final int totalBoxes;
  SummaryDialog({Key? key, required this.tagId, required this.totalBoxes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int jars = totalBoxes * 6;
    return AlertDialog(
      title: const Text(
        'Summary',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total box scanned: $totalBoxes Boxes",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Total items: $jars Jars",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "To: $tagId",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      actions: <Widget>[
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
            'Close',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
