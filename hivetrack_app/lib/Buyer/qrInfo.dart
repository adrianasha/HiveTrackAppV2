import 'package:flutter/material.dart';

import '../WebSocketService.dart';
import '../startPage.dart';

class QRInfo extends StatelessWidget {
  final String imageUrl;
  final Map<String, dynamic> scannedData;

  QRInfo({required this.imageUrl, required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAEF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFAEF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // First image (scanned product)
            Image.asset(
              imageUrl,
              fit: BoxFit.contain, // Ensures the image is fully visible
              width: double.infinity,
            ),
            SizedBox(height: 20), // Space between images
            // Second image (certificate)
            Image.asset(
              'assets/cert.png', // Replace with actual certification image
              fit: BoxFit.contain, // Ensures the full image is visible
              width: double.infinity,
            ),
            SizedBox(height: 20), // Space between image and buttons
            // Row containing the buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Print button
                  ElevatedButton(
                    onPressed: () async {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200], // Button color
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    ),
                    child: Text(
                      'Print',
                      style: TextStyle(fontFamily:'Roboto',fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 5), // Space between buttons
                  // Done button
                  ElevatedButton(
                    onPressed: ()  async {
                      final companyLiveStorage = await WebSocketService().sendMessageAndWaitForResponse({
                        "type": "changedModeOfCompanyLiveStorageData",
                        "path": scannedData,
                        "value": 3
                      });

                      bool success = companyLiveStorage["success"] ?? false;
                      if (success == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Startpage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200], // Button color
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(fontFamily:'Roboto', fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Additional space at the bottom
          ],
        ),
      ),
    );
  }
}
