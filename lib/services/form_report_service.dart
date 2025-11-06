import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:live_crime_reporter/supabase/supa_config.dart';

class CrimeReportService {
  final supabase = Supabase.instance.client;

  // Submit a new crime report
  Future<void> submitCrimeReport(Map<String, dynamic> reportData) async {
    try {
      // Insert report data into the crime_report table
      final response = await supabase.from('crime_report').insert(reportData).select();
      
      // Return the created report if needed
      print("Crime report submitted successfully: ${response.toString()}");
    } catch (e) {
      print("ERROR submitting crime report: $e");
      print(StackTrace.current);
      throw 'Failed to submit crime report: $e';
    }
  }
  
  // Get the current user's numeric ID from the users table
  Future<int?> getCurrentUserId() async {
    try {
      // Get the current authenticated user's UUID
      final String? authUserId = supabase.auth.currentUser?.id;
      
      if (authUserId == null) {
        throw 'No authenticated user found';
      }
      
      // Query the users table to get the numeric ID using the UUID
      final response = await supabase
          .from('users')
          .select('id')
          .eq('uuid', authUserId)
          .single();
      
      return response['id'] as int;
    } catch (e) {
      print("ERROR getting current user ID: $e");
      throw 'Failed to get current user ID: $e';
    }
  }
  
  // Update user points after submitting a report (for gamification)
  Future<void> updateUserPoints(int userId, int pointsToAdd) async {
    try {
      // First get current user data
      final response = await supabase
          .from('users')
          .select('points, level')
          .eq('id', userId)
          .single();
      
      int currentPoints = response['points'] ?? 0;
      int currentLevel = response['level'] ?? 1;
      
      // Calculate new points
      int newPoints = currentPoints + pointsToAdd;
      
      // Simple level calculation (adjust as needed)
      // Every 100 points = 1 level
      int newLevel = (newPoints / 100).floor() + 1;
      if (newLevel < 1) newLevel = 1;
      
      // Update user with new points and level
      await supabase
          .from('users')
          .update({
            'points': newPoints,
            'level': newLevel,
          })
          .eq('id', userId);
          
      print("User points updated successfully");
    } catch (e) {
      print("ERROR updating user points: $e");
      throw 'Failed to update user points: $e';
    }
  }
}