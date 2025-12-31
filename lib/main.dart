import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'firebase_options.dart';
// Import the local notification service
import 'services/local_notification_service.dart';
import 'package:live_crime_reporter/supabase/supa_config.dart'; // Ensure you have this service implemented
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage for onboarding and preferences
  await GetStorage.init();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized successfully");
  } catch (e) {
    print("❌ Firebase initialization error: $e");
    // Continue anyway - Firebase might not be critical for basic functionality
  }

  try {
    // Initialize Supabase
    await MySupabaseClient.initialize();
    print("✅ Supabase initialized successfully");
  } catch (e) {
    print("❌ Supabase initialization error: $e");
    print("⚠️  App will continue but authentication features may not work");
    // Don't crash the app - show error to user instead
  }

  try {
    // Print FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token"); // Print the FCM token to the terminal
  } catch (e) {
    print("⚠️  FCM token error: $e");
  }

  try {
    // Ensure location permissions are granted before launching the app
    await _checkLocationPermission();
  } catch (e) {
    print("⚠️  Location permission error: $e");
  }

  try {
    // Listen for foreground messages
    FirebaseMessaging.onBackgroundMessage(FCMService.backgroundHandler);
    
    // Initialize FCM Service
    FCMService fcmService = FCMService();
    await fcmService.initializeFCM();
  } catch (e) {
    print("⚠️  FCM Service error: $e");
  }

  runApp(App());
}

// Function to request location permission
Future<void> _checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
}

