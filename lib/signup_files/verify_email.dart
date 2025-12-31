
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:live_crime_reporter/signup_files/successscreen.dart';
import 'package:live_crime_reporter/supabase/supa_config.dart';

import '../../login_files/loginscreen.dart';
import '../../utils/constants/helperfunctions.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/constants/text_strings.dart';

class VerifyEmailController extends GetxController {
  final supabase = MySupabaseClient.instance.client;
  final isLoading = false.obs;
  final isChecking = false.obs;
  final resendCooldown = 60.obs; // 60 seconds cooldown
  Timer? _cooldownTimer;

  @override
  void onInit() {
    super.onInit();
    _startCooldownTimer();
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    resendCooldown.value = 60;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> checkEmailVerificationStatus() async {
    try {
      isChecking.value = true;
      
      // Refresh the session to get latest user data
      await supabase.auth.refreshSession();
      
      final user = supabase.auth.currentUser;
      
      if (user != null && user.emailConfirmedAt != null) {
        // Email is verified
        Get.to(() => SuccessScreen(
          image: TImages.success,
          title: TText.youraccountcreatedtitle,
          subtitle: TText.youraccountcreatedsubtitle,
          onPressed: () => Get.offAll(() => const LoginScreen()),
        ));
      } else {
        Get.snackbar(
          'Email Not Verified',
          'Please check your email and click the verification link.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange[800]!,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check verification status. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> resendVerificationEmail() async {
    if (resendCooldown.value > 0) {
      Get.snackbar(
        'Please Wait',
        'Please wait ${resendCooldown.value} seconds before resending.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange[800]!,
      );
      return;
    }

    try {
      isLoading.value = true;
      final user = supabase.auth.currentUser;
      
      if (user != null && user.email != null) {
        // Use the resend method with email parameter
        await supabase.auth.resend(
          type: OtpType.signup,
          email: user.email!,
        );

        Get.snackbar(
          'Email Sent',
          'Verification email has been resent. Please check your inbox.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[800]!,
        );

        _startCooldownTimer(); // Restart cooldown
      } else {
        Get.snackbar(
          'Error',
          'No user found. Please sign up again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend email: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String get userEmail {
    final user = supabase.auth.currentUser;
    return user?.email ?? '';
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel();
    super.onClose();
  }
}

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    final userEmail = controller.userEmail.isNotEmpty 
        ? controller.userEmail 
        : (email ?? 'your email');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TextSizes.defaultSpace),
          child: Column(
            children: [
              Image(
                image: const AssetImage(TImages.verifyemail),
                width: THelperFunction.screenWidth(context) * 0.6,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              Text(
                TText.confirmemail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              Text(
                userEmail,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: TextSizes.spacebtwSections,
              ),
              Text(
                "Please verify your email address to complete your account setup. Check your inbox for the verification link.",
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TextSizes.spacebtwSections),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isChecking.value
                          ? null
                          : () => controller.checkEmailVerificationStatus(),
                      child: controller.isChecking.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Continue"),
                    ),
                  )),
              const SizedBox(
                height: TextSizes.spaceBtwItems,
              ),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: controller.isLoading.value ||
                              controller.resendCooldown.value > 0
                          ? null
                          : () => controller.resendVerificationEmail(),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              controller.resendCooldown.value > 0
                                  ? "${TText.resendEmailIn} ${controller.resendCooldown.value}s"
                                  : TText.resendEmail,
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
