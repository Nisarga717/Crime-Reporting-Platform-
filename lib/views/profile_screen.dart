import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_crime_reporter/utils/constants/colors.dart';
import 'package:live_crime_reporter/supabase/user_service.dart';
import 'package:live_crime_reporter/login_files/loginscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final supabase = Supabase.instance.client;
  
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isEditing = false;
  
  // Controllers for editing
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pincodeController;
  late TextEditingController languageController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    pincodeController = TextEditingController();
    languageController = TextEditingController();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic>? data;
      
      // Try to get by numeric ID first
      final userIdInt = int.tryParse(widget.userId);
      if (userIdInt != null) {
        data = await _userService.getUserDetails(widget.userId);
      }
      
      // If not found, try by UUID
      if (data == null) {
        final authUser = supabase.auth.currentUser;
        if (authUser != null) {
          final response = await supabase
              .from('users')
              .select()
              .eq('uuid', authUser.id)
              .maybeSingle();
          data = response;
        }
      }

      if (data != null) {
        setState(() {
          userData = data;
          _populateControllers();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _populateControllers() {
    if (userData != null) {
      firstNameController.text = userData!['first_name'] ?? '';
      lastNameController.text = userData!['last_name'] ?? '';
      emailController.text = userData!['email'] ?? '';
      phoneController.text = userData!['phone_number'] ?? '';
      addressController.text = userData!['address'] ?? '';
      cityController.text = userData!['city'] ?? '';
      stateController.text = userData!['state'] ?? '';
      pincodeController.text = userData!['pincode']?.toString() ?? '';
      languageController.text = userData!['language'] ?? '';
    }
  }

  Future<void> _saveProfile() async {
    try {
      final updatedData = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'phone_number': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'pincode': int.tryParse(pincodeController.text.trim()) ?? 0,
        'language': languageController.text.trim(),
      };

      final userId = userData!['id'].toString();
      await _userService.updateUserDetails(userId, updatedData);
      
      setState(() {
        isEditing = false;
      });
      
      _loadUserData(); // Reload to get updated data
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: TColors.primaryColor.withOpacity(0.1),
        colorText: TColors.primaryColor,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.tertiaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!isLoading && userData != null)
            IconButton(
              icon: Icon(isEditing ? Icons.close : Icons.edit),
              onPressed: () {
                if (isEditing) {
                  _populateControllers(); // Reset to original values
                }
                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Failed to load profile data'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Header
                      _buildProfileHeader(),
                      
                      // Stats Cards
                      _buildStatsSection(),
                      
                      // Profile Information
                      _buildProfileInfo(),
                      
                      // Settings Section
                      _buildSettingsSection(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    final firstName = userData!['first_name'] ?? '';
    final lastName = userData!['last_name'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final email = userData!['email'] ?? '';
    final points = userData!['points'] ?? 0;
    final level = userData!['level'] ?? 1;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primaryColor, TColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Center(
              child: Text(
                fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: TColors.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fullName.isNotEmpty ? fullName : 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          // Points and Level
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBadge(Icons.stars, '$points', 'Points'),
              const SizedBox(width: 24),
              _buildStatBadge(Icons.trending_up, 'Level $level', 'Level'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    // Mock stats - replace with actual data from database
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMiniStat('Reports', '12', Icons.report_problem, TColors.primaryColor),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _buildMiniStat('Resolved', '8', Icons.check_circle, Colors.green),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _buildMiniStat('Pending', '4', Icons.pending, Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoField('First Name', firstNameController, Icons.person, isEditing),
          _buildInfoField('Last Name', lastNameController, Icons.person_outline, isEditing),
          _buildInfoField('Email', emailController, Icons.email, false), // Email not editable
          _buildInfoField('Phone', phoneController, Icons.phone, isEditing),
          _buildInfoField('Address', addressController, Icons.location_on, isEditing),
          Row(
            children: [
              Expanded(
                child: _buildInfoField('City', cityController, Icons.location_city, isEditing),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoField('State', stateController, Icons.map, isEditing),
              ),
            ],
          ),
          _buildInfoField('Pincode', pincodeController, Icons.pin, isEditing),
          _buildInfoField('Language', languageController, Icons.language, isEditing),
          
          if (isEditing) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, IconData icon, bool editable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: editable,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: TColors.primaryColor),
              filled: true,
              fillColor: editable ? Colors.grey[50] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: TColors.primaryColor, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingTile(
            Icons.notifications_outlined,
            'Notifications',
            'Manage notification settings',
            () {},
          ),
          const Divider(),
          _buildSettingTile(
            Icons.security,
            'Privacy & Security',
            'Manage your privacy settings',
            () {},
          ),
          const Divider(),
          _buildSettingTile(
            Icons.help_outline,
            'Help & Support',
            'Get help and contact support',
            () {},
          ),
          const Divider(),
          _buildSettingTile(
            Icons.info_outline,
            'About',
            'App version and information',
            () {},
          ),
          const Divider(),
          _buildSettingTile(
            Icons.logout,
            'Logout',
            'Sign out from your account',
            _logout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? Colors.red : TColors.primaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : TColors.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

