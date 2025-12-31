import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../signup_files/resetscreen.dart';
import '../utils/constants/text_sizes.dart';
import '../utils/constants/text_strings.dart';
import '../utils/constants/validators.dart';
import '../supabase/supa_config.dart';

class ForgotPasswordController extends GetxController {
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  final supabase = MySupabaseClient.instance.client;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendPasswordResetEmail() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
        redirectTo: 'io.supabase.flutterquickstart://reset-password',
      );

      Get.snackbar(
        'Success',
        'Password reset email sent! Please check your inbox.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green[800]!,
        duration: const Duration(seconds: 4),
      );

      // Navigate to reset screen
      Get.to(() => ResetScreen(email: emailController.text.trim()));
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
        'Failed to send reset email. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TextSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TText.forgottitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: TextSizes.spacebtwSections,
            ),
            Text(
              TText.forgotsubtitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: TextSizes.spacebtwSections * 2,
            ),
            Form(
              key: controller.forgotPasswordFormKey,
              child: TextFormField(
                controller: controller.emailController,
                validator: TValidator.validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: TText.email,
                  prefixIcon: Icon(Iconsax.direct_right),
                  hintText: 'Enter your email address',
                ),
              ),
            ),
            const SizedBox(height: TextSizes.spacebtwSections),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.sendPasswordResetEmail(),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(TText.submit),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
