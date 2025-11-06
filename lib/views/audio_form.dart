import 'package:flutter/material.dart';
import 'dart:io';
import '../services/bridgefy_service.dart'; // Import the service
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

class IncidentFormScreen extends StatefulWidget {
  final File audioFile;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic> updatedData) onSubmit;

  const IncidentFormScreen({
    super.key,
    required this.audioFile,
    required this.initialData,
    required this.onSubmit,
  });

  @override
  _IncidentFormScreenState createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  late TextEditingController _incidentTypeController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;
  late TextEditingController _perpetratorController;
  late TextEditingController _detailsController;
  late TextEditingController _transcriptionController;
  late TextEditingController _severityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _incidentTypeController =
        TextEditingController(text: widget.initialData['incident_type'] ?? '');
    _locationController =
        TextEditingController(text: widget.initialData['location'] ?? '');
    _timeController =
        TextEditingController(text: widget.initialData['time'] ?? '');
    _perpetratorController =
        TextEditingController(text: widget.initialData['perpetrator'] ?? '');
    _detailsController =
        TextEditingController(text: widget.initialData['details'] ?? '');
    _transcriptionController =
        TextEditingController(text: widget.initialData['transcription'] ?? '');
    _severityController =
        TextEditingController(text: widget.initialData['severity'] ?? '');
  }

  @override
  void dispose() {
    _incidentTypeController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    _perpetratorController.dispose();
    _detailsController.dispose();
    _transcriptionController.dispose();
    _severityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'incident_type': _incidentTypeController.text,
        'location': _locationController.text,
        'time': _timeController.text,
        'perpetrator': _perpetratorController.text,
        'severity of incident': _severityController.text, // Updated key
        'details': _detailsController.text,
      };

      // Send the data using BridgefyService
      _sendDataViaBridgefyService(updatedData);

      // Call the original onSubmit callback
      widget.onSubmit(updatedData);
    }
  }

  void _sendDataViaBridgefyService(Map<String, dynamic> data) async {
    try {
      // Get the BridgefyService instance
      final bridgefyService = BridgefyService();
      bridgefyService.initialize();
      // Use the sendReport method from the service
      final lastMessageId = await bridgefyService.sendReport(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Report sent via mesh network (ID: $lastMessageId)')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send report: $e')),
      );
      print('Error sending data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define theme colors
    final primaryColor = Color(0xFF2E7D32); // Dark green
    final secondaryColor = Color(0xFFAED581); // Light green
    final backgroundColor = Color(0xFFF5F9F5); // Very light green/off-white
    final textColor = Color(0xFF263238); // Dark blue-grey

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card for transcription
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.record_voice_over, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Voice Transcription',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _transcriptionController,
                        readOnly: true,
                        maxLines: 4,
                        style: TextStyle(color: textColor.withOpacity(0.8)),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Card for incident details
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.report_problem, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Incident Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Incident Type',
                        icon: Icons.category,
                        controller: _incidentTypeController,
                        primaryColor: primaryColor,
                        textColor: textColor,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter incident type'
                            : null,
                      ),
                      _buildTextField(
                        label: 'Location',
                        icon: Icons.location_on,
                        controller: _locationController,
                        primaryColor: primaryColor,
                        textColor: textColor,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter location' : null,
                      ),
                      _buildTextField(
                        label: 'Time',
                        icon: Icons.access_time,
                        controller: _timeController,
                        primaryColor: primaryColor,
                        textColor: textColor,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter time' : null,
                      ),
                      _buildTextField(
                        label: 'Perpetrator',
                        icon: Icons.person,
                        controller: _perpetratorController,
                        primaryColor: primaryColor,
                        textColor: textColor,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter perpetrator details'
                            : null,
                      ),
                      _buildTextField(
                        label: 'Severity',
                        icon: Icons.warning,
                        controller: _severityController,
                        primaryColor: primaryColor,
                        textColor: textColor,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter severity' : null,
                      ),
                      _buildTextField(
                        label: 'Additional Details',
                        icon: Icons.notes,
                        controller: _detailsController,
                        primaryColor: primaryColor,
                        textColor: textColor,
                        maxLines: 4,
                        validator: (value) => value!.isEmpty
                            ? 'Please enter additional details'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Marked as async
                    // Submit logic here
                    if (_formKey.currentState!.validate()) {
                      final updatedData = {
                        'incident_type': _incidentTypeController.text,
                        'location': _locationController.text,
                        'time': _timeController.text,
                        'perpetrator': _perpetratorController.text,
                        'severity of incident':
                            _severityController.text, // Updated key
                        'details': _detailsController.text,
                        'fcmToken': await FirebaseMessaging.instance
                            .getToken(), // Get FCM token
                        'timestamp': FieldValue.serverTimestamp(),
                      };

                      // Add the data to Firestore
                      await FirebaseFirestore.instance
                          .collection('formSubmissions')
                          .add(updatedData);

                      // Show success message and gamification popup
                      _showSuccessSnackbar("Report submitted successfully");
                      _showGamificationPopup();

                      // Optionally, navigate back or clear the form
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Report',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required Color primaryColor,
    required Color textColor,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showGamificationPopup() {
    // Implement your gamification popup logic here
  }
}
