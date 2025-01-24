import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../EssentialFunctions.dart';
import '../NavBar.dart';

class CompanyAgentRequest extends StatelessWidget {
  final Map<String, dynamic> dataMap;
  final String role;
  String? selectedAgentId;

  CompanyAgentRequest({super.key, required this.dataMap, required this.role});

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
                style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 500, // Set the desired width
              height: 600, // Set the desired height
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
                  if (role == "Dropship_Agent") ...[
                    SizedBox(height: 16.0),
                    Text(
                      'Agent Assigned:',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0, fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    FutureBuilder<Map<String, dynamic>>(
                      future: getAllVerifiedUsersByCID(dataMap["company_id"], 0), // Call your async function
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show a loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No items available');
                        }

                        final verifiedData = snapshot.data!;

                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: null,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber, width: 1.5), // Amber horizontal line
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber, width: 2.0), // Thicker amber line when focused
                            ),
                            hintText: 'Select an option',
                            hintStyle: TextStyle(fontFamily: 'Roboto', fontSize: 12.0, fontWeight: FontWeight.bold),
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0), // Adjust spacing around the dropdown
                          ),
                          items: [
                            ...verifiedData.entries.map((entry) {
                              var agentId = entry.value["id"];
                              var coveredAgentCount = entry.value["covered_agent"]?.length ?? 0;

                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text('$agentId ($coveredAgentCount)',  style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0, fontWeight: FontWeight.normal)
                                ),
                              );
                            })
                          ],
                          onChanged: (value) {
                            selectedAgentId = value;
                          },
                        );
                      },
                    )
                  ],
                  SizedBox(height: 230),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        if (role == "Dropship_Agent") {
                          if (selectedAgentId != null) {
                            final dropship_docRef = FirebaseFirestore.instance
                                .collection("Dropship_Agent")
                                .doc(dataMap["user_id"]);
                            await dropship_docRef.update({
                              'verified': true,
                              'selected_agent':selectedAgentId
                            });

                            final agent_docRef = FirebaseFirestore.instance
                                .collection("Agent")
                                .doc(selectedAgentId);

                            final agentSnapshot = await agent_docRef.get();

                            if (agentSnapshot.exists) {
                              List<dynamic> coveredAgentList = agentSnapshot.data()?['covered_agent'] ?? [];

                              coveredAgentList.add(dataMap["user_id"]);
                              await agent_docRef.update({
                                'covered_agent': coveredAgentList,
                              });
                            }
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select an Agent to be assigned to the Dropshipper Agent!', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey))),
                            );
                          }
                        } else {
                          final docRef = FirebaseFirestore.instance
                              .collection("Agent")
                              .doc(dataMap["user_id"]);
                          await docRef.update({
                            'verified': true,
                          });
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating verified field: $e', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey))),
                        );
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
