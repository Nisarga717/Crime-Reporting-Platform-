import 'package:flutter/material.dart';
import 'package:live_crime_reporter/supabase/supa_config.dart';
import 'package:live_crime_reporter/login_files/loginscreen.dart';
import 'package:live_crime_reporter/views/map_screen.dart';
import 'package:live_crime_reporter/onboarding_screen/boarding.dart';
import 'package:get_storage/get_storage.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _userId;
  String? _username;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      final supabase = MySupabaseClient.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null && user.emailConfirmedAt != null) {
        // User is authenticated and email is verified
        try {
          // Get user's numeric ID from users table
          final userData = await supabase
              .from('users')
              .select('id, first_name, last_name, email')
              .eq('uuid', user.id)
              .maybeSingle();

          if (userData != null) {
            _userId = userData['id']?.toString() ?? user.id;
            _username = userData['email']?.split('@')[0] ?? 
                       '${userData['first_name']} ${userData['last_name']}'.trim() ?? 
                       'User';
          } else {
            _userId = user.id;
            _username = user.email?.split('@')[0] ?? 'User';
          }
          
          setState(() {
            _isAuthenticated = true;
            _isLoading = false;
          });
        } catch (e) {
          print("Error fetching user data: $e");
          // Still allow login with UUID
          _userId = user.id;
          _username = user.email?.split('@')[0] ?? 'User';
          setState(() {
            _isAuthenticated = true;
            _isLoading = false;
          });
        }
      } else {
        // User is not authenticated or email not verified
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error checking auth state: $e");
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F8E9),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7CB342),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.shield,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Satark Setu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7CB342),
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CB342)),
              ),
            ],
          ),
        ),
      );
    }

    // Check if first time user (onboarding)
    final storage = GetStorage();
    final isFirstTime = storage.read('isFirstTime') ?? true;

    if (isFirstTime) {
      return const OnBoardingScreen();
    }

    // Route based on authentication state
    if (_isAuthenticated && _userId != null) {
      return MapScreen(
        userId: _userId!,
        callid: '928382',
        username: _username ?? 'User',
      );
    } else {
      return const LoginScreen();
    }
  }
}

