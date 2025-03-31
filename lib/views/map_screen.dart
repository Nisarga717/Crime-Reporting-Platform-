import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:math' as math;

class AppTheme {
  // Primary colors
  static const Color primary = Color(0xFF3F51B5); // Indigo
  static const Color primaryDark = Color(0xFF303F9F); // Dark Indigo
  static const Color primaryLight = Color(0xFFC5CAE9); // Light Indigo

  // Accent colors
  static const Color accent = Color(0xFFFF5722); // Deep Orange
  static const Color accentLight = Color(0xFFFFCCBC); // Light Orange

  // Functional colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue

  // Neutral colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Font sizes
  static const double fontSizeXSmall = 12.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Elevation
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentLocation = LatLng(20.5937, 78.9629);
  LatLng? _selectedLocation;
  File? _selectedVideo;
  File? _selectedAudio;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAnonymous = false;
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Add variables to track swipe gesture

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation, 15.0);
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
    });
    _showActionPopup();
  }

  // Show popup with 3 action buttons
  void _showActionPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusXLarge),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),

              // Header with location info
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLarge),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSmall),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          child: Icon(
                            Icons.report_problem_outlined,
                            color: AppTheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingMedium),
                        const Expanded(
                          child: Text(
                            "Report Incident",
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeXLarge,
                              fontWeight: AppTheme.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppTheme.info,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingSmall),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected Location",
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}",
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    fontWeight: AppTheme.medium,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLarge),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLarge),
                child: Column(
                  children: [
                    _buildActionButton(
                      icon: Icons.videocam,
                      label: "Record Video Evidence",
                      description: "Capture video of the incident",
                      onTap: _recordVideo,
                      color: AppTheme.error,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    _buildActionButton(
                      icon: Icons.mic,
                      label: "Record Audio Statement",
                      description: "Provide verbal details of the incident",
                      onTap: _recordAudio,
                      color: AppTheme.info,
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    _buildActionButton(
                      icon: Icons.edit_note,
                      label: "Submit Written Report",
                      description: "Fill out a detailed incident report",
                      onTap: _showCrimeReportForm,
                      color: AppTheme.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingXLarge),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          onTap: () {
            Navigator.pop(context); // Close popup
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: AppTheme.fontSizeMedium,
                          fontWeight: AppTheme.semiBold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textHint,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _recordVideo() async {
    // Show options dialog for video recording
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          elevation: AppTheme.elevationLarge,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: AppTheme.error,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                const Text(
                  "Record Video Evidence",
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeXLarge,
                    fontWeight: AppTheme.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Text(
                  "Choose how you want to capture video evidence",
                  style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingLarge),
                _buildVideoOptionButton(
                  icon: Icons.videocam,
                  label: "Record New Video",
                  description: "Hold to record a new video",
                  color: AppTheme.error,
                  onPressed: () async {
                    Navigator.pop(context);

                    // Open the hold-to-record camera screen
                    final videoFile = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HoldToRecordCamera(),
                      ),
                    );

                    if (videoFile != null) {
                      setState(() {
                        _selectedVideo = videoFile;
                      });
                      // Show confirmation
                      _showSuccessSnackbar("Video recorded successfully");
                    }
                  },
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                _buildVideoOptionButton(
                  icon: Icons.photo_library,
                  label: "Choose Existing Video",
                  description: "Select a video from your gallery",
                  color: AppTheme.info,
                  onPressed: () async {
                    Navigator.pop(context);

                    final pickedFile = await ImagePicker().pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedVideo = File(pickedFile.path);
                      });
                      // Show confirmation
                      _showSuccessSnackbar("Video selected from gallery");
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoOptionButton({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSmall),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: AppTheme.fontSizeMedium,
                          fontWeight: AppTheme.semiBold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeXSmall,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textHint,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Add success snackbar
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppTheme.spacingSmall),
            Text(message),
          ],
        ),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        margin: const EdgeInsets.all(AppTheme.spacingMedium),
      ),
    );
  }

  Future<void> _recordAudio() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AudioRecorderWidget(
          onAudioSaved: (File audioFile) {
            setState(() {
              _selectedAudio = audioFile;
            });
            // Show confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Audio recorded successfully"),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }

  void _showCrimeReportForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusXLarge),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppTheme.divider,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_note,
                            color: AppTheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "Crime Report Form",
                            style: TextStyle(
                              fontSize: AppTheme.fontSizeXXLarge,
                              fontWeight: AppTheme.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Please provide details about the incident",
                        style: TextStyle(
                          fontSize: AppTheme.fontSizeSmall,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMedium),
                      decoration: BoxDecoration(
                        color: AppTheme.info.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                        border:
                            Border.all(color: AppTheme.info.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppTheme.info,
                            size: 24,
                          ),
                          const SizedBox(width: AppTheme.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected Location",
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    fontWeight: AppTheme.medium,
                                    color: AppTheme.info,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${_selectedLocation!.latitude.toStringAsFixed(5)}, ${_selectedLocation!.longitude.toStringAsFixed(5)}",
                                  style: TextStyle(
                                    fontSize: AppTheme.fontSizeSmall,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        fontWeight: AppTheme.semiBold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: "Describe what you witnessed...",
                        hintStyle: TextStyle(color: AppTheme.textHint),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          borderSide: BorderSide(color: AppTheme.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          borderSide: BorderSide(color: AppTheme.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          borderSide:
                              BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: AppTheme.background,
                        contentPadding:
                            const EdgeInsets.all(AppTheme.spacingMedium),
                      ),
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Evidence",
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        fontWeight: AppTheme.semiBold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildAttachmentButton(
                          icon: Icons.video_file,
                          label: "Video",
                          isAttached: _selectedVideo != null,
                          onPressed: _recordVideo,
                        ),
                        const SizedBox(width: 12),
                        _buildAttachmentButton(
                          icon: Icons.mic,
                          label: "Audio",
                          isAttached: _selectedAudio != null,
                          onPressed: _recordAudio,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: CheckboxListTile(
                        title: const Text(
                          "Report Anonymously",
                          style: TextStyle(
                            fontWeight: AppTheme.semiBold,
                            fontSize: AppTheme.fontSizeMedium,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "Your identity will not be disclosed",
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: AppTheme.fontSizeSmall,
                          ),
                        ),
                        value: _isAnonymous,
                        activeColor: AppTheme.primary,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isAnonymous = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: AppTheme.elevationMedium,
                          shadowColor: AppTheme.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                        ),
                        onPressed: () {
                          // Submit logic here
                          Navigator.pop(context);
                          // Show success message and gamification popup
                          _showSuccessSnackbar("Report submitted successfully");
                          _showGamificationPopup();
                        },
                        child: const Text(
                          "SUBMIT REPORT",
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeMedium,
                            fontWeight: AppTheme.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required bool isAttached,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isAttached ? Colors.white : AppTheme.textSecondary,
            size: 22,
          ),
          label: Text(
            isAttached ? "Attached" : label,
            style: TextStyle(
              color: isAttached ? Colors.white : AppTheme.textPrimary,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isAttached ? AppTheme.success : AppTheme.background,
            elevation: isAttached ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              side: BorderSide(
                color: isAttached ? AppTheme.success : AppTheme.divider,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Satark Setu",
              style: TextStyle(
                fontWeight: AppTheme.bold,
                fontSize: AppTheme.fontSizeLarge,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
            onPressed: () {
              // Show notifications
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.help_outline, color: Colors.white),
            ),
            onPressed: () {
              // Show help
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GestureDetector(
        // Track the start of horizontal drag

        // Track the end of horizontal drag

        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 5.0,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                // Add markers for current location
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      width: 40,
                      height: 40,
                      child: _buildPulsingLocationMarker(),
                    ),
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: _buildSelectedLocationMarker(),
                      ),
                  ],
                ),
              ],
            ),

            // Add a floating action button for current location - moved to very bottom right
            Positioned(
              bottom: 20, // Reduced distance from bottom
              right: 20, // Consistent distance from right
              child: FloatingActionButton(
                backgroundColor: AppTheme.primary,
                elevation: AppTheme.elevationMedium,
                onPressed: () {
                  _getUserLocation();
                },
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ),

            // Add a hint card at the top
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: AppTheme.elevationSmall,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.info),
                      const SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: Text(
                          "Tap on the map to report an incident",
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: AppTheme.fontSizeSmall,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close,
                            size: 16, color: AppTheme.textHint),
                        onPressed: () {
                          // Hide the hint
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Add a swipe indicator on the right edge
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: SizedBox(
                width: 20,
                child: Center(
                  child: Container(
                    height: 80,
                    width: 5,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add these new methods for the markers
  Widget _buildPulsingLocationMarker() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40 * (1 + (value * 0.3)),
              height: 40 * (1 + (value * 0.3)),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.3 * (1 - value)),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primary,
                  width: 4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedLocationMarker() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  // Method to open the right screen with animation

  // Add this method to show the gamification popup
  void _showGamificationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: GamificationPopup(
            points: 50,
            message: "Thank you for making your community safer!",
          ),
        );
      },
    );
  }
}

class HoldToRecordCamera extends StatefulWidget {
  const HoldToRecordCamera({super.key});

  @override
  _HoldToRecordCameraState createState() => _HoldToRecordCameraState();
}

class _HoldToRecordCameraState extends State<HoldToRecordCamera> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isInitialized = false;
  String? _videoPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  Future<void> _startRecording() async {
    if (!_isInitialized || _isRecording) return;

    try {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isInitialized || !_isRecording) return;

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoPath = videoFile.path;
      });

      // Return the recorded video file
      Navigator.pop(context, File(_videoPath!));
    } catch (e) {
      print('Error stopping video recording: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_cameraController!),
          ),

          // Recording indicator
          if (_isRecording)
            Positioned(
              top: 40,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 12),
                    SizedBox(width: 8),
                    Text(
                      'REC',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Close button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Hold to record button
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onLongPressStart: (_) => _startRecording(),
                onLongPressEnd: (_) => _stopRecording(),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? Colors.red : Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Press and hold to record',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioRecorderWidget extends StatefulWidget {
  final Function(File) onAudioSaved;

  const AudioRecorderWidget({super.key, required this.onAudioSaved});

  @override
  _AudioRecorderWidgetState createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  // Add animation controller for recording animation
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _initAudioPlayer();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _initAudioPlayer() {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _checkPermission() async {
    if (!await _recorder.hasPermission()) {
      await _recorder.hasPermission();
    }
  }

  Future<void> _startRecording() async {
    try {
      // Create a temporary file path for the recording
      final directory = await getTemporaryDirectory();
      final String path =
          '${directory.path}/audio_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Configure recording options
      final RecordConfig config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );

      // Start recording with the specified path and config
      await _recorder.start(config, path: path);

      setState(() {
        _isRecording = true;
        _recordedFilePath = null;
      });

      // Start animation
      _animationController.repeat(reverse: true);
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _recorder.stop();

      setState(() {
        _isRecording = false;
        _recordedFilePath = path;
      });

      // Stop animation
      _animationController.stop();

      // Set the audio source when recording is complete
      if (_recordedFilePath != null) {
        // Use setSource instead of setFilePath
        await _audioPlayer.setSource(DeviceFileSource(_recordedFilePath!));
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  Future<void> _playPauseAudio() async {
    if (_recordedFilePath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    color: AppTheme.info,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Record Audio Statement",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isRecording
                  ? "Recording in progress..."
                  : _recordedFilePath != null
                      ? "Recording completed"
                      : "Press the button to start recording",
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 30),

            // Recording visualization
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(color: AppTheme.divider),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: _isRecording
                    ? _buildRecordingWaveform()
                    : _recordedFilePath != null
                        ? _buildAudioPlayer()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mic_none_rounded,
                                size: 48,
                                color: AppTheme.textHint,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Ready to record",
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: AppTheme.fontSizeSmall,
                                ),
                              ),
                            ],
                          ),
              ),
            ),

            const SizedBox(height: 30),

            // Recording controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRecording && _recordedFilePath == null)
                  _buildControlButton(
                    icon: Icons.mic,
                    label: "Start Recording",
                    color: AppTheme.info,
                    onPressed: _startRecording,
                  ),
                if (_isRecording)
                  _buildControlButton(
                    icon: Icons.stop,
                    label: "Stop Recording",
                    color: AppTheme.error,
                    onPressed: _stopRecording,
                  ),
                if (_recordedFilePath != null && !_isRecording)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildControlButton(
                            icon: Icons.refresh,
                            label: "Record Again",
                            color: AppTheme.warning,
                            onPressed: _startRecording,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildControlButton(
                            icon: Icons.check_circle,
                            label: "Use Recording",
                            color: AppTheme.success,
                            onPressed: () {
                              if (_recordedFilePath != null) {
                                widget.onAudioSaved(File(_recordedFilePath!));
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
        shadowColor: color.withOpacity(0.5),
      ),
    );
  }

  Widget _buildRecordingWaveform() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            9,
            (index) {
              // Create animated bars with different heights based on animation value
              final double animValue = 0.3 +
                  (0.7 *
                      (1.0 -
                          ((_animationController.value - (index / 9.0)).abs() *
                                  2.5)
                              .clamp(0.0, 1.0)));

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 10 + (50 * animValue),
                decoration: BoxDecoration(
                  color: AppTheme.info.withOpacity(0.6 + (0.4 * animValue)),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAudioPlayer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(_isPlaying
              ? Icons.pause_circle_filled
              : Icons.play_circle_filled),
          color: AppTheme.info,
          iconSize: 48,
          onPressed: _playPauseAudio,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  activeTrackColor: AppTheme.info,
                  inactiveTrackColor: AppTheme.info.withOpacity(0.2),
                  thumbColor: AppTheme.info,
                  overlayColor: AppTheme.info.withOpacity(0.2),
                ),
                child: Slider(
                  value: _position.inMilliseconds.toDouble(),
                  max: _duration.inMilliseconds > 0
                      ? _duration.inMilliseconds.toDouble()
                      : 1.0,
                  min: 0.0,
                  onChanged: (value) {
                    final position = Duration(milliseconds: value.toInt());
                    _audioPlayer.seek(position);
                  },
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_position),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: AppTheme.medium,
                    ),
                  ),
                  Text(
                    _formatDuration(_duration),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: AppTheme.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GamificationPopup extends StatefulWidget {
  final int points;
  final String message;

  const GamificationPopup({
    super.key,
    required this.points,
    required this.message,
  });

  @override
  State<GamificationPopup> createState() => _GamificationPopupState();
}

class _GamificationPopupState extends State<GamificationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Simplified scale animation without TweenSequence
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));

    _controller.forward();

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          // Use a simpler scale animation that starts small and grows
          scale: 0.5 + (0.5 * _scaleAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hero badge with animation
                  Transform.rotate(
                    angle: _rotationAnimation.value * math.pi,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Simplified animated rings
                          ...List.generate(3, (index) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(seconds: 1 + index),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: (1.0 - value) * 0.7,
                                  child: Transform.scale(
                                    scale: 0.5 + (value * 0.5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.primary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),

                          // Hero icon
                          Icon(
                            Icons.shield,
                            size: 60,
                            color: AppTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),

                  // Rest of the widget remains unchanged
                  const Text(
                    "Neighbourhood Hero!",
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeXXLarge,
                      fontWeight: AppTheme.bold,
                      color: AppTheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),

                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSizeMedium,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLarge,
                      vertical: AppTheme.spacingMedium,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: Border.all(
                        color: AppTheme.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          color: AppTheme.success,
                          size: 28,
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        Text(
                          "+${widget.points}",
                          style: const TextStyle(
                            fontSize: AppTheme.fontSizeXLarge,
                            fontWeight: AppTheme.bold,
                            color: AppTheme.success,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        const Text(
                          "points",
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeMedium,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingLarge,
                        vertical: AppTheme.spacingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        fontWeight: AppTheme.semiBold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
