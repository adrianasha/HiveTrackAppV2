import 'package:flutter/material.dart';
import '../NavBar.dart';

class CompanyAgentRequest extends StatelessWidget {
  // Define a list of details
  final List<Map<String, String>> agentDetails = [
    {'label': 'Full Name', 'value': 'Ahmad Syaamil Thaqif Bin Shalizan'},
    {'label': 'Agent ID', 'value': 'AG1005'},
    {'label': 'Email', 'value': 'thaqif@gmail.com'},
    {'label': 'Phone number', 'value': '012-7358442'},
    {'label': 'Address', 'value': '35, Jalan Damai Budi 6, Alam Damai, 56000 Cheras, Kuala Lumpur'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Handle back button press
          },
        ),
        title: Text(
          'Agent Request',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Agent Details',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamically generate the InfoRows
                  ...agentDetails.map((detail) => InfoRow(
                    label: detail['label']!,
                    value: detail['value']!,
                  )),
                  SizedBox(height: 300),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Handle accept request action
                    },
                    child: Center(
                      child: Text(
                        'Accept Request',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black45),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0, // Set the initial tab index
        role: 'Company', // Pass the role to the reusable NavBar
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$label :',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black, fontWeight: FontWeight.w100)),
          ),
        ],
      ),
    );
  }
}
