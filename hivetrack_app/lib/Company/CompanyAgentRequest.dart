import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';

class CompanyAgentRequest extends StatelessWidget {
  final Map<String, dynamic> dataMap;

  CompanyAgentRequest({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {

    String name = dataMap["name"] ?? 'Unknown';
    String iD = dataMap["id"] ?? 'No ID provided';
    String email = dataMap["email"] ?? 'No email provided';
    String phoneNumber = dataMap["telephone"] ?? 'No phone number provided';
    String address = dataMap["address"] ?? 'No address provided';

    final List<Map<String, String>> agentDetails = [
      {'label': 'Full Name', 'value': name},
      {'label': 'ID', 'value': iD},
      {'label': 'Email', 'value': email},
      {'label': 'Phone number', 'value': phoneNumber},
      {'label': 'Address', 'value': address},
    ];

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
                    onPressed: () async {
                      try {
                        final docRef = FirebaseFirestore.instance
                            .collection(dataMap["role"])
                            .doc(dataMap["user_id"]);
                        await docRef.update({
                          'verified': true,
                        });
                        Navigator.pop(context);
                      } catch (e) {
                        print('Error updating verified field: $e');
                      }
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
