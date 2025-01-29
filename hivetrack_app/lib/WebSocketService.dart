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
  String? _uid;
  final Map<String, Completer<dynamic>> _pendingRequests = {};
  final Duration _reconnectDelay = Duration(seconds: 20);
  bool _isReconnecting = false;
  int registerTried = 0;

  Future<void> connect(String url) async {
    _url = url;

    try {
      _webSocket = await WebSocket.connect(url);
      print('Connected to WebSocket at $url');
      _isReconnecting = false;
      _uid = await getCurrentAuthUserId();

      _webSocket?.listen((message) {
        if (message == 'ping') {
          _webSocket?.add('pong');
          print('Sent: pong');
        }
        print('Received: $message');
          try {
            _handleMessage(message);
          } catch (e) {
            print('Error processing message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _reconnect();
        },
        onDone: () {
          print('WebSocket connection closed.');
          _reconnect();
        },
      );
      await setUID(_uid!);
    } catch (e) {
      print('Failed to connect: $e');
      _reconnect();
    }
  }

  Future<void> setUID(String uid) async {
    _uid = uid;

    try {
      print('Set current websocket Uid: $uid');
      dynamic RegistrationResponse = await sendMessageAndWaitForResponse({
        'type': 'register',
        'clientType': 'User',
        'uid':_uid
      });
      registerTried = registerTried + 1;

      dynamic success = RegistrationResponse["success"];
      if (success) {
        print("Finished Register");
      } else {
        if (registerTried <= 3) {
          setUID(_uid!);
        } else if (registerTried > 3 && registerTried <= 6) {
          _uid = await getCurrentAuthUserId();
          setUID(_uid!);
        } else if (registerTried >= 6) {
          registerTried = 0;
        }
      }
    } catch (e) {
      print('Failed to register: $e');
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

  bool isConnected() {
    if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
      return true;
    } else {
      return false;
    }
  }

  void _handleMessage(dynamic message) {
    final response = jsonDecode(message);
    final String? responseId = response["responseId"];

    if (responseId != null && _pendingRequests.containsKey(responseId)) {
      print("Pending Request Response :");
      print(message);
      _pendingRequests[responseId]!.complete(response);
      _pendingRequests.remove(responseId);
    }
  }

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

  void sendMessage(String message) {
    if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
      _webSocket!.add(message);
      print('Message sent: $message');
    } else {
      print('WebSocket is not connected.');
    }
  }

  void close() {
    _webSocket?.close();
    _webSocket = null;
  }
}