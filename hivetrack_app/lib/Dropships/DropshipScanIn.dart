import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DropshipScanIn extends StatefulWidget {
  @override
  _DropshipScanInState createState() => _DropshipScanInState();
}

class _DropshipScanInState extends State<DropshipScanIn> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  int selectedMode = 0; // 0 for Scan In, 1 for Scan Out

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(
        cameras[0], // Use the first available camera
        ResolutionPreset.high,
      );
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Scan Inventory",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Camera background
          if (_isCameraInitialized)
            CameraPreview(_cameraController)
          else
            Center(
              child: CircularProgressIndicator(),
            ),

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
                style: TextStyle(fontFamily: 'Roboto', fontSize: 23, color: Colors.white
                ),
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
                onPressed: () {
                  // Add scanning action
                },
                child: const Text(
                  "Start Scanning",
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
