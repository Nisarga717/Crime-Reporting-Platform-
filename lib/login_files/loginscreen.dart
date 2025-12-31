import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:live_crime_reporter/views/map_screen.dart';
import '../signup_files/signup.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/helperfunctions.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_sizes.dart';
import '../utils/constants/text_strings.dart';
import '../utils/constants/validators.dart';
import 'forgotpassword.dart';
// Import your Supabase client
import '../supabase/supa_config.dart'; // Update with correct path

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  // Get Supabase client using your singleton
  final supabase = MySupabaseClient.instance.client;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Email and password sign in
  Future<void> emailAndPasswordSignIn() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = response.user;

      if (user != null) {
        // Check if email is verified
        if (user.emailConfirmedAt == null) {
          Get.snackbar(
            'Email Not Verified',
            'Please verify your email before logging in. Check your inbox for the verification link.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.1),
            colorText: Colors.orange[800]!,
            duration: const Duration(seconds: 5),
          );
          isLoading.value = false;
          return;
        }

        // Get user's numeric ID from users table
        try {
          final userData = await supabase
              .from('users')
              .select('id')
              .eq('uuid', user.id)
              .maybeSingle();

          final userId = userData?['id']?.toString() ?? user.id;

          Get.offAll(() => MapScreen(
                userId: userId,
                callid: '928382',
                username: user.email?.split('@')[0] ?? 'User',
              ));
        } catch (e) {
          // If user doesn't exist in users table, still allow login with UUID
          Get.offAll(() => MapScreen(
                userId: user.id,
                callid: '928382',
                username: user.email?.split('@')[0] ?? 'User',
              ));
        }
      } else {
        Get.snackbar(
          'Authentication Error',
          'Invalid email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } on AuthException catch (e) {
      String errorMessage = e.message;
      if (e.message.contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password. Please try again.';
      } else if (e.message.contains('Email not confirmed')) {
        errorMessage = 'Please verify your email before logging in.';
      }
      Get.snackbar(
        'Authentication Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign In
  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      // Note: For OAuth providers, you'll handle the redirect in your app's initialization
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: TextSizes.appbarheight,
            bottom: TextSizes.defaultSpace,
            right: TextSizes.defaultSpace,
            left: TextSizes.defaultSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                height: 150,
                image:
                    AssetImage(dark ? TImages.darkapplogo : TImages.loginlogo),
              ),
              Text(
                TText.logintitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TextSizes.sm),
              Text(
                TText.loginsubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Form(
                key: controller.loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: TextSizes.spacebtwSections),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.emailController,
                        validator: (value) => TValidator.validateEmail(value),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: TText.email,
                        ),
                      ),
                      const SizedBox(height: TextSizes.spaceBtwInputfeilds),
                      Obx(() => TextFormField(
                            controller: controller.passwordController,
                            validator: (value) =>
                                TValidator.validateEmptyText('Password', value),
                            expands: false,
                            obscureText: controller.hidePassword.value,
                            decoration: InputDecoration(
                              labelText: TText.password,
                              prefixIcon: const Icon(Iconsax.password_check),
                              suffixIcon: IconButton(
                                onPressed: () => controller.hidePassword.value =
                                    !controller.hidePassword.value,
                                icon: Icon(controller.hidePassword.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye),
                              ),
                            ),
                          )),
                      const SizedBox(height: TextSizes.spaceBtwInputfeilds / 2),
                      // Remember me and forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: (value) => controller.rememberMe
                                        .value = !controller.rememberMe.value,
                                  )),
                              const Text(TText.remember),
                            ],
                          ),
                          TextButton(
                            onPressed: () =>
                                Get.to(() => const ForgotPassword()),
                            child: const Text(TText.forget),
                          ),
                        ],
                      ),
                      const SizedBox(height: TextSizes.spacebtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.emailAndPasswordSignIn(),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(TText.signin),
                            )),
                      ),
                      const SizedBox(height: TextSizes.spacebtwSections),
                      const SizedBox(height: TextSizes.spaceBtwItems),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Get.to(() => const SignupScreen()),
                          child: const Text(TText.createAccount),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: dark ? TColors.darkgrey : TColors.lightgrey,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(
                    TText.signinwith,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Flexible(
                    child: Divider(
                      color: dark ? TColors.darkgrey : TColors.lightgrey,
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: TextSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.containerDark),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () => controller.googleSignIn(),
                      icon: const Image(
                        width: TextSizes.iconmd,
                        height: TextSizes.iconmd,
                        image: AssetImage(TImages.google),
                      ),
                    ),
                  ),
                  const SizedBox(width: TextSizes.spaceBtwItems),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.containerDark),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Facebook auth can be implemented similarly
                        Get.snackbar(
                          'Coming Soon',
                          'Facebook authentication will be available soon!',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      icon: const Image(
                        width: TextSizes.iconmd,
                        height: TextSizes.iconmd,
                        image: AssetImage(TImages.facebook),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
