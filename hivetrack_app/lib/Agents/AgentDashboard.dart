import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hivetrack_app/Agents/ScanIn.dart';
import 'package:intl/intl.dart';
import '../EssentialFunctions.dart';
import '../NavBar.dart';
import '../WebSocketService.dart';
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
  String ScannerCode = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentAuthUserId(),
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
            future: getUserDataWithParentName(userId!),
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
                userData["uid"] = userId;
                username = userData["name"] ?? "Unknown";

                final userDocRef = FirebaseFirestore.instance.collection('Agent').doc(userId);
                userDocRef.update({"Inventory.Mode": "None"}).catchError((error) {
                  debugPrint("Failed to update Mode: $error");
                });

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
                  style: const TextStyle(
                    fontFamily: 'Roboto', fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black,
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
                          style: TextStyle(
                            fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          todayDate,
                          style: TextStyle(
                            fontFamily: 'Roboto', fontSize: 16,
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
                              style: const TextStyle(
                                fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Stock In",
                              style: TextStyle(
                                fontFamily: 'Roboto', fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "$stockOutCount",
                              style: const TextStyle(
                                fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Stock Out",
                              style: TextStyle(
                                fontFamily: 'Roboto', fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "60",
                              style: const TextStyle(
                                fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Available",
                              style: TextStyle(
                                fontFamily: 'Roboto', fontSize: 16,
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
                mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 120, // Fixed width for all buttons
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final WebSocketService _webSocketService = WebSocketService();
                          dynamic AwaitedData = await _webSocketService.sendMessageAndWaitForResponse({
                            "type": "isConnectionCodeValid",
                            "code": "supply ness Ages Bingus"
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScanIn(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_upward_outlined, color: Colors.black),
                        label: const Text(
                          "Stock In",
                          style: TextStyle(
                            fontFamily: 'Roboto', fontSize: 14, color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[200],
                          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Space between buttons
                  Flexible(
                    child: SizedBox(
                      width: 120, // Fixed width for all buttons
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScanOut(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_downward, color: Colors.black),
                        label: const Text(
                          "Stock Out",
                          style: TextStyle(
                            fontFamily: 'Roboto', fontSize: 14, color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[200],
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Space between buttons
                  Flexible(
                    child: SizedBox(
                      width: 120, // Fixed width for all buttons
                      child: ElevatedButton(
                        onPressed: () {
                          // Use a context higher in the widget tree
                          final parentContext = context;

                          showDialog(
                            context: parentContext,
                            builder: (BuildContext context) {
                              List<TextEditingController> _controllers = List.generate(
                                6,
                                    (index) => TextEditingController(), // Initialize empty controllers
                              );
                              String? errorMessage;

                              return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  return AlertDialog(
                                    backgroundColor: const Color(0xFFFBD46D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                    titlePadding: EdgeInsets.all(0),
                                    content: SizedBox(
                                      width: 330,
                                      height: 180, // Increased height to accommodate error message
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            'To connect scanner',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Enter the code displayed on the screen",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: List.generate(6, (index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                                child: SizedBox(
                                                  width: 40,
                                                  child: TextField(
                                                    controller: _controllers[index],
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    maxLength: 1,
                                                    style: const TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize: 24,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      counterText: '',
                                                      border: const UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white),
                                                      ),
                                                      focusedBorder: const UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white, width: 2),
                                                      ),
                                                    ),
                                                    onChanged: (value) async {
                                                      if (value.length == 1 && index < 5) {
                                                        FocusScope.of(context).nextFocus();
                                                      } else if (value.isEmpty && index > 0) {
                                                        FocusScope.of(context).previousFocus();
                                                      }

                                                      // Check code dynamically
                                                      String enteredCode = _controllers
                                                          .map((controller) => controller.text)
                                                          .join();
                                                      if (enteredCode.length == 6) {
                                                        final WebSocketService _webSocketService = WebSocketService();
                                                        dynamic AwaitedData = await _webSocketService.sendMessageAndWaitForResponse({
                                                          "type": "connectUserToScanner",
                                                          "code": enteredCode,
                                                          "uid": userData["uid"]
                                                        });
                                                        if (AwaitedData && AwaitedData["isCodeValid"]) {
                                                          Navigator.pop(context); // Close the AlertDialog
                                                          Future.delayed(
                                                            const Duration(milliseconds: 200),
                                                                () {
                                                              showDialog(
                                                                context: parentContext, // Use parentContext
                                                                builder: (BuildContext context) {
                                                                  return Dialog(
                                                                    backgroundColor: Colors.amber[100],
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.all(20),
                                                                      child: const Text(
                                                                        'Scanner connected successfully!',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontFamily: 'Roboto',
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.brown,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          setState(() {
                                                            errorMessage = 'Wrong code entered';
                                                          });
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          if (errorMessage != null) // Display error message if exists
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Text(
                                                errorMessage!,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[200],
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.wifi_outlined, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Scanner',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
