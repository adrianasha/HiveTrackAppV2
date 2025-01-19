import 'package:flutter/material.dart';
import '../NavBar.dart';

class CompanyDropshipRequest extends StatelessWidget {
  final String role; // Add the role parameter for the NavBar

  CompanyDropshipRequest({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Use pop to go back to the previous page
          },
        ),
        title: Text(
          'Dropship Agent Request',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dropship Agent Requests',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 16),
                _buildDetailRow('Full Name', 'Yusuf Bin Aiman'),
                _buildDetailRow('Agent ID', 'DSAG10001'),
                _buildDetailRow('Email', 'yusuf@gmail.com'),
                _buildDetailRow('Phone number', '012-7358442'),
                _buildDetailRow(
                    'Address',
                    '35, Jalan Damai Budi 6, Alam Damai, 56000 Cheras, Kuala Lumpur'),
                SizedBox(height: 16),
                Text(
                  'Agent Assigned',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'AG1001',
                      child: Text('AG1001 (0)'),
                    ),
                  ],
                  onChanged: (value) {
                    // Handle selection
                    print('Selected Agent ID: $value');
                  },
                  hint: Text('Agent IDs'),
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle accept request action
                      print('Accept Request Button Pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[300], // Background color
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Accept Request',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1, // Set the index for the Notifications tab
        role: role, // Pass the role to the reusable NavBar
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label :',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
