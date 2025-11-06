import 'package:flutter/material.dart';

class CrimeReportController {
  // Form controllers
  final TextEditingController perpetratorController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController incidentTypeController = TextEditingController();

  // Selected values
  String selectedSeverity = 'Medium'; // Default value
  DateTime reportDate = DateTime.now();
  String reportTime =
      DateTime.now().toLocal().toString().split(' ')[1].split('.')[0];

  // Coordinates
  double? latitude;
  double? longitude;

  // Constructor with optional coordinates
  CrimeReportController({this.latitude, this.longitude});

  // Get form data as a map
  Map<String, dynamic> getFormData(int userId) {
    return {
      'user_id': userId,
      'date': reportDate.toString().split(' ')[0],
      'time': reportTime,
      'perpetrator': perpetratorController.text,
      'details': detailsController.text,
      'report_type': 'Incident Report', // Fixed value based on the form
      'incident_type': incidentTypeController.text,
      'status': 'New', // Fixed value based on the form
      'severity': selectedSeverity,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  // Validate form data
  String? validateForm() {
    if (perpetratorController.text.isEmpty) {
      return 'Please enter perpetrator information';
    }

    if (detailsController.text.isEmpty) {
      return 'Please provide details about the incident';
    }

    if (incidentTypeController.text.isEmpty) {
      return 'Please enter incident type';
    }

    if (latitude == null || longitude == null) {
      return 'Location coordinates are required';
    }

    return null; // No errors
  }

  // Set severity value
  void setSeverity(String value) {
    selectedSeverity = value;
  }

  // Clean up resources
  void dispose() {
    perpetratorController.dispose();
    detailsController.dispose();
    incidentTypeController.dispose();
  }
}
