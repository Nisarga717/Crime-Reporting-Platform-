import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_crime_reporter/supabase/user_service.dart';
import 'package:live_crime_reporter/signup_files/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  
  // Form key
  final signupFormKey = GlobalKey<FormState>();
  
  // Form controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final address = TextEditingController();
  final pincode = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final language = TextEditingController();
  final password = TextEditingController();
  
  // UI controls
  final hidepassword = true.obs;
  final privacypolicy = false.obs;
  
  // User service for database operations
  final _userService = UserService();
  
  // Sign up process
  Future<void> signup() async {
    if (!_validateSignup()) return;
    
    try {
      // Create user model with form data
      // In SignupController.signup():
final userData = {
  'first_name': firstName.text.trim(),
  'last_name': lastName.text.trim(),
  'address': address.text.trim(),
  'pincode': int.tryParse(pincode.text.trim()) ?? 0, // Convert to int here
  'state': state.text.trim(),
  'city': city.text.trim(),
  'email': email.text.trim(),
  'phone_number': phoneNumber.text.trim(),
  'language': language.text.trim(),
  'points': 0,
  'level': 1,
};
      
      await _userService.createUser(userData, password.text.trim());
      
      // Navigate to verify email
      Get.to(() => const VerifyEmail());
    } catch (e) {
      // Handle any errors
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
  
  // Validation function
  bool _validateSignup() {
    if (!signupFormKey.currentState!.validate()) return false;
    if (!privacypolicy.value) {
      Get.snackbar(
        'Error',
        'Please accept the terms and conditions to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
    return true;
  }
  
  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    address.dispose();
    pincode.dispose();
    state.dispose();
    city.dispose();
    email.dispose();
    phoneNumber.dispose();
    language.dispose();
    password.dispose();
    super.dispose();
  }
}