import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'views/map_screen.dart'; // Import the map screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure location permissions are granted before launching the app
  await _checkLocationPermission();

  runApp(MyApp());
}

// Function to request location permission
Future<void> _checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crime Reporting App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(), // Display the MapScreen on startup
    );
  }
}
