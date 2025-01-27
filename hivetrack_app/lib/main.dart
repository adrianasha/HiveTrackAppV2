import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  // Import Firebase core
import 'home.dart';
import 'WebSocketService.dart';// Import your home screen

void main() async {
  final WebSocketService _webSocketService = WebSocketService();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _webSocketService.connect('ws://45.134.39.193:6159/ws');
  runApp(Home());
}