import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hivetrack_app/Dropships/DropshipDashboard.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:math';

import '../WebSocketService.dart';

class DropshipQRScan extends StatefulWidget {
  @override
  _DropshipQRScanState createState() => _DropshipQRScanState();
}

class _DropshipQRScanState extends State<DropshipQRScan> with WidgetsBindingObserver {
  MobileScannerController _cameraController = MobileScannerController();
  bool _isCameraInitialized = true;
  int selectedMode = 0;
  String? _scanFeedback;
  double _feedbackX = 0;
  double _feedbackY = 0;
  Random _random = Random();
  Map<String, List<String>> _scannedData = {};
  bool rebound = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // Listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  void _initializeCamera() {
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _cameraController.stop();
    } else if (state == AppLifecycleState.resumed) {
      _cameraController.start();
    }
  }

  void _showScanFeedback() {
    setState(() {
      _scanFeedback = "+1";
      print('+1');

      // Generate random positions within screen bounds
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      _feedbackX = _random.nextDouble() * (screenWidth - 50); // Keep inside width
      _feedbackY = _random.nextDouble() * (screenHeight - 200); // Avoid app bar & bottom

    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _scanFeedback = null;
      });
    });
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
                  rebound = false;
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _cameraController.dispose();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Scan Inventory",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          // Camera background
          if (_isCameraInitialized)
            Positioned.fill(
              child: MobileScanner(
                  controller: _cameraController,
                  onDetect: (capture) async {
                    if (rebound == true) return;
                    rebound = true;

                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                      try {
                        final barcodeJsonData = jsonDecode(barcodes.first.rawValue!);
                        if (barcodeJsonData is Map<String, dynamic> &&
                            barcodeJsonData.containsKey("parentRFID") &&
                            barcodeJsonData.containsKey("qrcode")) {

                          final userId = await getCurrentAuthUserId();
                          var docSnapshot = await FirebaseFirestore.instance
                              .collection("Dropship_Agent")
                              .doc(userId) // Replace with dynamic ID if needed
                              .get();

                          if (docSnapshot.exists) {
                            var data = docSnapshot.data();
                            final companyLiveStorage = await WebSocketService().sendMessageAndWaitForResponse({
                              "type": "fetchCompanyLiveStorage",
                              "cid": data?["company_id"],
                            });

                            print("SSSSUUU");
                            print(companyLiveStorage["LiveStorage"][barcodeJsonData["parentRFID"]][barcodeJsonData["qrcode"]]["CanBeSold"]);
                            if (companyLiveStorage["LiveStorage"] is Map && companyLiveStorage["LiveStorage"].containsKey(barcodeJsonData["parentRFID"]) && companyLiveStorage["LiveStorage"][barcodeJsonData["parentRFID"]].containsKey(barcodeJsonData["qrcode"]) && companyLiveStorage["LiveStorage"][barcodeJsonData["parentRFID"]][barcodeJsonData["qrcode"]]["CanBeSold"] != (selectedMode + 1) && companyLiveStorage["LiveStorage"][barcodeJsonData["parentRFID"]][barcodeJsonData["qrcode"]]["CanBeSold"] < 3) {
                              rebound = false;
                              setState(() {
                                if (_scannedData.containsKey(barcodeJsonData["parentRFID"])) {
                                  if (!_scannedData[barcodeJsonData["parentRFID"]]!.contains(barcodeJsonData["qrcode"])) {
                                    _scannedData[barcodeJsonData["parentRFID"]]!.add(barcodeJsonData["qrcode"]);
                                    _showScanFeedback();
                                  }
                                } else {
                                  _scannedData[barcodeJsonData["parentRFID"]] = [barcodeJsonData["qrcode"]];
                                  _showScanFeedback();
                                }
                              });
                            } else {
                              scanError();
                            }
                          }
                        }
                      } catch (e) {
                        print("Invalid JSON: ${barcodes.first.rawValue}");
                      }
                    }
                  }

              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          // UI Overlay
          Column(
            children: [
              const SizedBox(height: 15),
              // Sliding toggle for "Scan In" and "Scan Out"
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMode = 0; // Scan In selected
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedMode == 0 ? Colors.amber : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Scan In",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: selectedMode == 0 ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMode = 1; // Scan Out selected
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selectedMode == 1 ? Colors.amber : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Scan Out",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: selectedMode == 1 ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
              const Text(
                "Place QR code in the scan area",
                style: TextStyle(fontFamily: 'Roboto', fontSize: 23, color: Colors.white),
              ),
              const SizedBox(height: 30),
              // QR code scanner region with corner borders
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
                  if (_scanFeedback != null)
                    Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _scanFeedback != null ? 1.0 : 0.0,
                        child: Text(
                          _scanFeedback!,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              // Start Scanning button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBD46D),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final userId = await getCurrentAuthUserId();
                  var docSnapshot = await FirebaseFirestore.instance
                      .collection("Dropship_Agent")
                      .doc(userId) // Replace with dynamic ID if needed
                      .get();

                  if (docSnapshot.exists) {
                    var data = docSnapshot.data();
                    final qrscanLogic = await WebSocketService().sendMessageAndWaitForResponse({
                      "type": "updateDropshipAgentQRscan",
                      "userId": userId,
                      "scannedData": _scannedData,
                      "Mode": selectedMode
                    });
                    final FetchParentUserId = await WebSocketService().sendMessageAndWaitForResponse({
                      "type": "fetchDropShipAgentParentId",
                      "uid": data!["selected_agent"]
                    });

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Summary",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                selectedMode == 0
                                    ? "From: ${FetchParentUserId["ParentUserId"] ?? "Unknown"}\nTotal items: ${qrscanLogic["jarsScanned"]} Jars"
                                    : "Total items: ${qrscanLogic["jarsScanned"]} Jars\nSold!",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  //Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DropshipDashboard(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  "Done",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
