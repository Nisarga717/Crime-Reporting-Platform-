import 'package:supabase_flutter/supabase_flutter.dart';

class MySupabaseClient {
  static MySupabaseClient? _instance;
  late final SupabaseClient _supabaseClient;

  // Singleton pattern
  static Future<void> initialize() async {
    if (_instance == null) {
      await Supabase.initialize(
        url: 'https://vuilqikbakoyydfrjggt.supabase.co', // Replace with your Supabase URL
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1aWxxaWtiYWtveXlkZnJqZ2d0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM4NDMzMDYsImV4cCI6MjA1OTQxOTMwNn0.sL3Ef-D-UyxIVsISae7gIfXdZn0zIhFzQ-FnbsiBep0', // Replace with your Supabase anon key
      );
      _instance = MySupabaseClient._();
    }
  }

  MySupabaseClient._() {
    _supabaseClient = Supabase.instance.client;
  }

  static MySupabaseClient get instance {
    if (_instance == null) {
      throw Exception(
          'MySupabaseClient not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  SupabaseClient get client => _supabaseClient;
}
