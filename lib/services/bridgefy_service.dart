import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bridgefy/bridgefy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

class BridgefyService implements BridgefyDelegate {
  static final BridgefyService _instance = BridgefyService._internal();
  final Bridgefy _bridgefy = Bridgefy();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Stream controller to broadcast received reports to any listening widgets
  final _reportStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get reportStream =>
      _reportStreamController.stream;

  bool _isInitialized = false; // Track initialization state

  factory BridgefyService() {
    return _instance;
  }

  BridgefyService._internal();
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await BridgefyService().initialize();
    // Now you can safely send reports
  }

  Future<void> initialize() async {
    // Initialize notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(initSettings);

    // Initialize Bridgefy
    try {
      await _bridgefy.initialize(
        apiKey: "d3634391-56e0-48de-b07b-6f73421c2e17",
        delegate: this,
        verboseLogging: true,
      );

      // Start Bridgefy with a unique user ID
      final prefs = await SharedPreferences.getInstance();
      final Uuid uuid = Uuid();
      String userId = prefs.getString('user_id') ?? uuid.v4();
      prefs.setString('user_id', userId);

      await _bridgefy.start(
        userId: userId,
        propagationProfile: BridgefyPropagationProfile.standard,
      );

      _isInitialized = true; // Set initialized to true
      print("Bridgefy initialized and started with user ID: $userId");
    } catch (e) {
      print("Failed to initialize Bridgefy: $e");
    }
  }

  Future<String> sendReport(Map<String, dynamic> reportData) async {
    if (!_isInitialized) {
      throw Exception(
          "Bridgefy is not initialized. Please initialize before sending reports.");
    }

    try {
      final jsonData = jsonEncode(reportData);
      final dataToSend = Uint8List.fromList(utf8.encode(jsonData));

      final messageId = await _bridgefy.send(
        data: dataToSend,
        transmissionMode: BridgefyTransmissionMode(
          type: BridgefyTransmissionModeType.broadcast,
          uuid: await _bridgefy.currentUserID,
        ),
      );

      return messageId;
    } catch (e) {
      print("Error sending report: $e");
      rethrow;
    }
  }

  void dispose() {
    _reportStreamController.close();
    _bridgefy.stop();
  }

  // Store received reports locally
  Future<void> _storeReceivedReport(Map<String, dynamic> report) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> reports = prefs.getStringList('received_reports') ?? [];
    reports.add(jsonEncode(report));
    await prefs.setStringList('received_reports', reports);
  }

  // Show notification for received report
  Future<void> _showReportNotification(Map<String, dynamic> report) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'crime_reports_channel',
      'Crime Reports',
      channelDescription: 'Notifications for received crime reports',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    String incidentType = report['incident_type'] ?? 'Unknown incident';
    String location = report['location'] ?? 'Unknown location';

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'New Crime Report: $incidentType',
      'Location: $location',
      notificationDetails,
    );
  }

  // BridgefyDelegate implementation
  @override
  void bridgefyDidStart({required String currentUserID}) {
    print("Bridgefy started with user ID: $currentUserID");
  }

  @override
  void bridgefyDidFailToStart({required BridgefyError error}) {
    print("Bridgefy failed to start: $error");
  }

  @override
  void bridgefyDidStop() {
    print("Bridgefy stopped");
  }

  @override
  void bridgefyDidFailToStop({required BridgefyError error}) {
    print("Bridgefy failed to stop: $error");
  }

  @override
  void bridgefyDidDestroySession() {
    print("Bridgefy session destroyed");
  }

  @override
  void bridgefyDidFailToDestroySession() {
    print("Bridgefy failed to destroy session");
  }

  @override
  void bridgefyDidConnect({required String userID}) {
    print("Connected to peer: $userID");
  }

  @override
  void bridgefyDidDisconnect({required String userID}) {
    print("Disconnected from peer: $userID");
  }

  @override
  void bridgefyDidEstablishSecureConnection({required String userID}) {
    print("Established secure connection with: $userID");
  }

  @override
  void bridgefyDidFailToEstablishSecureConnection({
    required String userID,
    required BridgefyError error,
  }) {
    print("Failed to establish secure connection with $userID: $error");
  }

  @override
  void bridgefyDidSendMessage({required String messageID}) {
    print("Message sent successfully: $messageID");
  }

  @override
  void bridgefyDidFailSendingMessage({
    required String messageID,
    BridgefyError? error,
  }) {
    print("Failed to send message $messageID: $error");
  }

  @override
  void bridgefyDidReceiveData({
    required Uint8List data,
    required String messageId,
    required BridgefyTransmissionMode transmissionMode,
  }) {
    try {
      // Convert received data to a Map
      final String jsonString = utf8.decode(data);
      final Map<String, dynamic> reportData = jsonDecode(jsonString);

      print("Received crime report: $reportData");

      // Store the report locally
      _storeReceivedReport(reportData);

      // Show notification to the user
      _showReportNotification(reportData);

      // Broadcast to any listening widgets
      _reportStreamController.add(reportData);
    } catch (e) {
      print("Error processing received data: $e");
    }
  }

  @override
  void bridgefyDidSendDataProgress({
    required String messageID,
    required int position,
    required int of,
  }) {
    print("Sending progress for $messageID: $position of $of");
  }
}
