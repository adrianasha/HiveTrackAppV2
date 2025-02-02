import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QRInfo extends StatelessWidget {
  final String scannedData;

  QRInfo({required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[50],
      body: Center(
        child: Text(
          scannedData,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}