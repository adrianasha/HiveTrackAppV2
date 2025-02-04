import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hivetrack_app/Buyer/qrInfo.dart';
import 'package:hivetrack_app/WebSocketService.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../EssentialFunctions.dart';

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

  void scanError() {
    showDialog(
      context: context,
      barrierDismissible: false,  // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Center(  // Ensure it's centered
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Text(
              'The QR has been scanned.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isScanning = true; // Resume scanning when returning
                  });
                  Navigator.of(context).pop();  // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            onDetect: (capture) async {
              if (_isScanning) {
                setState(() {
                  _isScanning = false; // Stop scanning after a code is detected
                });

                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  try {
                    final barcodeJsonData = jsonDecode(barcodes.first.rawValue!);

                    if (barcodeJsonData is Map<String, dynamic> &&
                        barcodeJsonData.containsKey("parentRFID") &&
                        barcodeJsonData.containsKey("qrcode")) {

                      final companyLiveStorage = await WebSocketService().sendMessageAndWaitForResponse({
                        "type": "fetchAllLiveStorage"
                      });

                      bool successed = companyLiveStorage["success"] ?? false;
                      if (successed) {
                        Map<String, dynamic> liveStorage = companyLiveStorage["LiveStorageMap"] ?? {};

                        // Check if the scanned parentRFID exists in live storage
                        bool found = false;
                        bool hassend = false;
                        for (var companyId in liveStorage.keys) {
                          var storage = liveStorage[companyId];
                          if (storage.containsKey(barcodeJsonData["parentRFID"]) && storage[barcodeJsonData["parentRFID"]].containsKey(barcodeJsonData["qrcode"])) {
                            if (storage[barcodeJsonData["parentRFID"]][barcodeJsonData["qrcode"]]["CanBeSold"] < 3) {
                              found = true;
                              String imagePath = 'assets/honey-details.png'; // Change this path as needed

                              // Navigate to QRInfo with the image path
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QRInfo(imageUrl: imagePath, scannedData: barcodeJsonData),
                                ),
                              ).then((_) {
                                setState(() {
                                  _isScanning = true; // Resume scanning when returning
                                });
                              });
                              return;
                            } else {
                              hassend = true;
                              scanError();
                            }
                          }
                        }

                        // If the product is NOT found in Live Storage, show the warning alert
                        if (!found && !hassend) {
                          _showWarningDialog();
                        }
                      } else {
                        _showWarningDialog(); // Show warning if fetching Live Storage fails
                      }
                    } else {
                      _showWarningDialog(); // Show warning if JSON does not contain expected fields
                    }
                  } catch (e) {
                    print("Invalid JSON: ${barcodes.first.rawValue}");
                    _showWarningDialog(); // Show warning for invalid QR codes
                  }
                } else {
                  setState(() {
                    _isScanning = true;
                  });
                }
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

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Oh No! Warning!",
            style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.red),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                "The product might not be original. Please verify with the seller.",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  _isScanning = true; // Resume scanning when returning
                });
              },
              child: Text("OK",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
