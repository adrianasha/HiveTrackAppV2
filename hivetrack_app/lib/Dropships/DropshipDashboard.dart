import 'package:flutter/material.dart';
import '../NavBar.dart';

class DropshipDashboard extends StatefulWidget {
  const DropshipDashboard({Key? key}) : super(key: key);

  @override
  _DropshipDashboardState createState() => _DropshipDashboardState();
}

class _DropshipDashboardState extends State<DropshipDashboard> {
  String username = "Cindercella";
  int stockInCount = 0;
  int stockOutCount = 0;

  void updateCounts({int? newStockIn, int? newStockOut}) {
    setState(() {
      if (newStockIn != null) stockInCount = newStockIn;
      if (newStockOut != null) stockOutCount = newStockOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFBD46D),
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
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                      children: const [
                        Text(
                          "Today",
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Nov 18, 2024",
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
                            Text(
                              "$stockInCount",
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Stock Out",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.rss_feed, color: Colors.black),
                    label: const Text(
                      "Stock In Scan",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200],
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.rss_feed, color: Colors.black),
                    label: const Text(
                      "Stock Out Scan",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_download_outlined, color: Colors.black),
                    label: const Text(
                      "Stock In",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
                    ),
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
                    label: const Text(
                      "Stock Out",
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
                    ),
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
        currentIndex: 0,
        role: 'Dropship_Agent',
      ),
    );
  }
}
