import 'package:flutter/material.dart';
import 'package:live_crime_reporter/views/custom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Launch the URL when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchWebsite();
    });
  }

  void _launchWebsite() async {
    final link = "https://satarknity.vercel.app/"; // Replace with your community website URL

    try {
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      // Silently handle errors
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Container(), // Empty container when not loading
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // Assuming Community is at index 1, adjust if needed
        onTap: (index) {
          if (index != 1) { // Also adjust this if needed
            Navigator.of(context).pop();
            if (index != 0) {
              // Navigate to the appropriate screen based on index
            }
          }
        },
      ),
    );
  }
}