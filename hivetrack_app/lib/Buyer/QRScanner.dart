import 'package:flutter/material.dart';
import 'package:hivetrack_app/Buyer/qrInfo.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  MobileScannerController _cameraController = MobileScannerController();
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showWelcomePopup();
    });
  }

  void _showWelcomePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "Hi!",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 23, color: Colors.black),
              ),
              SizedBox(width: 10),
              Image.asset(
                'assets/beez.png', // Ensure this image is placed in your assets folder and declared in pubspec.yaml
                width: 40,
                height: 40,
              ),
            ],
          ),
          content: Text(
            "Please scan the QR code on the honey jar to make sure it is original.",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBD46D),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "QR code Scanner",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: _cameraController,
            onDetect: (capture) {
              if (_isScanning) {
                setState(() {
                  _isScanning = false; // Stop scanning after a code is detected
                });

                String scannedData = capture.barcodes.first.rawValue ?? "No data";

                // Navigate to black screen with scanned data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRInfo(scannedData: scannedData),
                  ),
                ).then((_) {
                  setState(() {
                    _isScanning = true; // Resume scanning when returning
                  });
                });
              }
            },
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.amber, width: 3),
                            left: BorderSide(color: Colors.amber, width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.amber, width: 3),
                            right: BorderSide(color: Colors.amber, width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.amber, width: 3),
                            left: BorderSide(color: Colors.amber, width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.amber, width: 3),
                            right: BorderSide(color: Colors.amber, width: 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Scanning code...",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}