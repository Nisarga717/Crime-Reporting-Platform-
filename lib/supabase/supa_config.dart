import 'package:supabase_flutter/supabase_flutter.dart';

class MySupabaseClient {
  static MySupabaseClient? _instance;
  late final SupabaseClient _supabaseClient;

  // Singleton pattern
  static Future<void> initialize() async {
    if (_instance == null) {
      await Supabase.initialize(
        url: 'https://qlpsbyhzgwypqdpeafha.supabase.co', // Replace with your Supabase URL
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFscHNieWh6Z3d5cHFkcGVhZmhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcxNzYzNDYsImV4cCI6MjA4Mjc1MjM0Nn0.FrKifz25DDWH7aZXrzFpBBB6hQLWHXOxETrmOMWxpRs', // Replace with your Supabase anon key
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
