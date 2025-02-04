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
  final Duration _reconnectDelay = Duration(seconds: 45);
  bool _isReconnecting = false;
  int registerTried = 0;

  Future<void> connect(String url) async {
    _url = url;
    _uid = await getCurrentAuthUserId();

    try {
      _webSocket = await WebSocket.connect(url);

      if (_webSocket == null) {
        throw Exception("WebSocket connection failed: Received null.");
      }

      print('Connected to WebSocket at $url');
      _isReconnecting = false;

      _webSocket?.listen(
            (message) {
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

      // Register user with WebSocket after connection is established
      await setUID(_uid);
    } catch (e) {
      print('Failed to connect: $e');
      _reconnect();
    }
  }

  Future<void> setUID(String? uid) async {
    try {
      //_uid = uid ?? "";
      String clientType = (_uid == null) ? "Guest" : "User"; // Determine client type

      print('Setting WebSocket UID as $clientType: $_uid');

      dynamic RegistrationResponse = await sendMessageAndWaitForResponse({
        'type': 'register',
        'clientType': clientType,
        'uid': _uid
      });

      registerTried++;

      if (RegistrationResponse != null && RegistrationResponse["success"]) {
        print("WebSocket Registered Successfully as $clientType");
      } else {
        if (registerTried <= 3) {
          //setUID(_uid); // Retry registration
        } else if (registerTried > 3 && registerTried <= 6) {
          _uid = await getCurrentAuthUserId(); // Try fetching UID again
          //setUID(_uid);
        } else {
          registerTried = 0; // Reset counter
        }
      }
    } catch (e) {
      print('Failed to register: $e');
      _reconnect();
    }
  }

  void _reconnect() {
    if (_isReconnecting) {
      print("Reconnect attempt skipped: Already trying.");
      return;
    }

    _isReconnecting = true;
    print('WebSocket reconnecting in $_reconnectDelay...');

    Future.delayed(_reconnectDelay, () {
      if (_url != null) {
        print('Attempting reconnection to $_url...');
        connect(_url!).catchError((e) {
          print("WebSocket reconnection failed: $e");
        });
      } else {
        print("Reconnection attempt failed: WebSocket URL is null.");
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
    if (_webSocket == null) {
      print("WebSocket error: Connection is null. Cannot send message.");
      return Future.error("WebSocket error: The connection was never established or has been closed.");
    }

    if (_webSocket!.readyState != WebSocket.open) {
      print("WebSocket error: Connection is not open. Current state: ${_webSocket!.readyState}");
      return Future.error("WebSocket error: Connection is in an invalid state (${_webSocket!.readyState}).");
    }

    final Completer<dynamic> completer = Completer<dynamic>();
    final String requestID = generateCustomId(13, true, false);

    print("Websocket Request being send");

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