import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'firebase_options.dart';
// Import the local notification service
import 'services/local_notification_service.dart';
import 'package:live_crime_reporter/supabase/supa_config.dart'; // Ensure you have this service implemented

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

await MySupabaseClient.initialize();
  // Print FCM token
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token"); // Print the FCM token to the terminal

  // Ensure location permissions are granted before launching the app
  await _checkLocationPermission();

  // Listen for foreground messages
  FirebaseMessaging.onBackgroundMessage(FCMService.backgroundHandler);
  //inapp

  // Initialize FCM Service
  FCMService fcmService = FCMService();
  await fcmService.initializeFCM();

  runApp(App());
}

// Function to request location permission
Future<void> _checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
}

