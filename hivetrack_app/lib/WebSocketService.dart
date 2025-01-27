import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hivetrack_app/EssentialFunctions.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocket? _webSocket;
  String? _url;
  bool _isConnected = false;
  final Map<String, Completer<dynamic>> _pendingRequests = {};
  final Duration _reconnectDelay = Duration(minutes: 1);
  bool _isReconnecting = false;

  Future<void> connect(String url) async {
    _url = url;

    try {
      _webSocket = await WebSocket.connect(url);
      print('Connected to WebSocket at $url');
      _isReconnecting = false;

      _webSocket?.listen((message) {
        print('Received: $message');
        _handleMessage(message);
      }, onError: (error) {
        print('WebSocket error: $error');
        _reconnect();
      }, onDone: () {
        print('WebSocket connection closed.');
        _reconnect();
      });
    } catch (e) {
      print('Failed to connect: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    if (_isReconnecting) return;

    _isReconnecting = true;
    print('Reconnecting in $_reconnectDelay...');
    Future.delayed(_reconnectDelay, () {
      if (_url != null) {
        print('Attempting reconnection...');
        connect(_url!);
      } else {
        _isReconnecting = false;
      }
    });
  }

  // Future<void> connect(String url) async {
  //   _url = url;
  //   while (!_isConnected) {
  //     try {
  //       print('Attempting to connect to WebSocket...');
  //       _webSocket = await WebSocket.connect(url);
  //       print('Connected to WebSocket: $url');
  //
  //       await _sendRegistrationMessage();
  //
  //       _webSocket!.listen(
  //         null,
  //         onDone: _handleDisconnection,
  //         onError: (error) {
  //           print('WebSocket error: $error');
  //           _handleDisconnection();
  //         },
  //       );
  //
  //       _isConnected = true;
  //     } catch (e) {
  //       print('Failed to connect: $e');
  //       _scheduleReconnect();
  //     }
  //   }
  // }
  void _handleMessage(dynamic message) {
    final response = jsonDecode(message);
    final String? responseId = response["responseId"];

    if (responseId != null && _pendingRequests.containsKey(responseId)) {
      _pendingRequests[responseId]!.complete(response);
      _pendingRequests.remove(responseId);
    }
  }

  Future<void> _sendRegistrationMessage() async {
    final Completer<void> completer = Completer<void>();

    String requestID = generateCustomId(13, true, false);
    final registrationMessage = jsonEncode({
      'requestId': requestID,
      'request': {
        'type': 'register',
        'clientType': 'User',
      },
    });

    _webSocket!.add(registrationMessage);

    dynamic subscription;
    subscription = _webSocket!.listen((message) {
      final response = jsonDecode(message);
      if (response["responseId"] && response["responseId"] == requestID) {
        if (response['success'] == true) {
          completer.complete();
        } else {
          completer.completeError('Registration failed: $response');
        }

        subscription.cancel();
      }
    });

    return completer.future;
  }


  // Future<dynamic> sendMessageAndWaitForResponse(dynamic message) async {
  //   final Completer<dynamic> completer = Completer<dynamic>();
  //
  //   String requestID = generateCustomId(13, true, false);
  //   final registrationMessage = jsonEncode({
  //     'requestId': requestID,
  //     'request': message,
  //   });
  //
  //   _webSocket!.add(registrationMessage);
  //
  //   dynamic subscription;
  //   subscription = _webSocket!.listen((message) {
  //     final response = jsonDecode(message);
  //     if (response["responseId"] && response["responseId"] == requestID) {
  //       completer.complete(response["response"]);
  //       subscription.cancel();
  //     }
  //   });
  //
  //   return completer.future;
  // }
  Future<dynamic> sendMessageAndWaitForResponse(dynamic message) async {
    final Completer<dynamic> completer = Completer<dynamic>();
    final String requestID = generateCustomId(13, true, false);

    final registrationMessage = jsonEncode({
      'requestId': requestID,
      'request': message,
    });

    // Store completer with request ID
    _pendingRequests[requestID] = completer;

    // Send the message
    _webSocket!.add(registrationMessage);

    return completer.future;
  }

  void _handleDisconnection() {
    print('WebSocket disconnected.');
    _isConnected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isConnected) return;
    print('Reconnecting in ${_reconnectDelay.inSeconds} seconds...');
    Future.delayed(_reconnectDelay, () {
      if (_url != null) {
        connect(_url!);
      } else {
        print('No URL available for reconnection.');
      }
    });
  }

  void sendMessage(String message) {
    if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
      _webSocket!.add(message);
      print('Message sent: $message');
    } else {
      print('WebSocket is not connected.');
    }
  }

  void close() {
    _isConnected = false;
    _webSocket?.close();
    _webSocket = null;
  }
}