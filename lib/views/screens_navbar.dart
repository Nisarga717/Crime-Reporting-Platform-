// These are placeholder screen classes for navigation purposes
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_navbar.dart';
import 'analytics_dashboard.dart';

class AnalyticsScreen extends StatelessWidget {
  final String userId;
  
  const AnalyticsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return AnalyticsDashboard(userId: userId);
  }
}


class VirtualEscortScreen extends StatefulWidget {
  @override
  _VirtualEscortScreenState createState() => _VirtualEscortScreenState();
}

class _VirtualEscortScreenState extends State<VirtualEscortScreen> {
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
    final link = 'https://satark-sehli.vercel.app/'; // Replace with your actual URL

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
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
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

class OfflineReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Reporting')),
      body: Center(child: Text('Report Crimes While Offline')),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {
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