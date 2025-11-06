import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:live_crime_reporter/supabase/supa_config.dart';

class UserService {
  final supabase = Supabase.instance.client;

  // Function to create a new user and save their profile data
  Future<void> createUser(
      Map<String, dynamic> userData, String password) async {
    try {
      // Step 1: Register user with email and password
      final AuthResponse authResponse = await supabase.auth.signUp(
        email: userData['email'],
        password: password,
      );

      // Get the user ID from the response (we'll use this for auth operations only)
      final String authUserId = authResponse.user!.id;
      print("Auth user created successfully with ID: $authUserId");

      // Step 2: Generate a numeric ID for the database
      // This is a simple way to generate a random integer - you might want a more robust method
      final int databaseUserId = DateTime.now().millisecondsSinceEpoch;

      // Step 3: Prepare data for database insertion with proper type conversion
      final userDataToInsert = {
        'id': databaseUserId, // Use numeric ID instead of UUID
        
        'first_name': userData['first_name'].toString(),
        'last_name': userData['last_name'].toString(),
        'address': userData['address'].toString(),
        'pincode': userData['pincode'] is String
            ? int.tryParse(userData['pincode']) ?? 0
            : userData['pincode'],
        'state': userData['state'].toString(),
        'city': userData['city'].toString(),
        'email': userData['email'].toString(),
        'phone_number': userData['phone_number'].toString(),
        'language': userData['language'].toString(),
        'points': 0,
        'level': 1,
        'uuid':
            authUserId, // Store the auth UUID in a separate column for reference
      };

      // Step 4: Insert user profile data into the database
      await supabase.from('users').insert(userDataToInsert);
      print("User data inserted successfully");
    } catch (e) {
      print("ERROR creating user: $e");
      print(StackTrace.current);
      throw 'Failed to create user: $e';
    }
  }

  // Get user details from Supabase
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final response =
          await supabase.from('users').select().eq('id', userId).single();

      return response;
    } catch (e) {
      throw 'Failed to get user details: $e';
    }
  }

  // Update user details
  Future<void> updateUserDetails(
      String userId, Map<String, dynamic> data) async {
    try {
      await supabase.from('users').update(data).eq('id', userId);
    } catch (e) {
      throw 'Failed to update user details: $e';
    }
  }
}
