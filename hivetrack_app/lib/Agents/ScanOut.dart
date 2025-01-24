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

  // Controllers for the 6-digit code
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());

  String getEnteredCode() {
    return _controllers.map((controller) => controller.text).join();
  }

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
                    builder: (context) => const HistoryPage(), // Replace with your HistoryPage widget
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
                const SizedBox(height: 20),
                const Text(
                  "Scanning box...",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
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
                    "To: AG1004",
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

          // Start Scanning / Done Button Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!isScanning) {
                    // Show the 6-digit code dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFFFBD46D),
                          title: const Text(
                            "Enter the code displayed on the screen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return SizedBox(
                                    width: 40, // Width of each digit box
                                    child: TextField(
                                      controller: _controllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 1, // Limit to one digit per box
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '', // Hides the counter (0/1)
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.white, width: 2),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.length == 1 && index < 5) {
                                          FocusScope.of(context)
                                              .nextFocus(); // Automatically move to the next box
                                        } else if (value.isEmpty && index > 0) {
                                          FocusScope.of(context)
                                              .previousFocus(); // Move to the previous box if empty
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          actions: [
                            SizedBox(
                              width: double.infinity, // Stretch the button horizontally
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber[50], // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding
                                ),
                                onPressed: () {
                                  // Your button action
                                },
                                child: const Text(
                                  "Enter",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 17,
                                    color: Colors.black,
                                  ), // Text color
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Perform the done action
                    setState(() {
                      isScanning = false;
                    });
                  }
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

// Placeholder for HistoryPage
class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: const Center(
        child: Text("This is the History page."),
      ),
    );
  }
}
