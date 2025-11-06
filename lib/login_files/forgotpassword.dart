import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../signup_files/resetscreen.dart';
import '../utils/constants/text_sizes.dart';
import '../utils/constants/text_strings.dart';
import '../utils/constants/validators.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
   // final controller = Get.put(ForgetPasswordController());
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
              //key: controller.forgetPasswordFormkey,
              child: TextFormField(
                //controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                  labelText: TText.email,
                  prefixIcon: Icon(Iconsax.direct_right),
                ),
              ),
            ),
            const SizedBox(height: TextSizes.spacebtwSections,),
            SizedBox(
              width:double.infinity,
              child: ElevatedButton(
                onPressed:()=> Get.off(()=>const ResetScreen(email: '',)),
                //onPressed: controller.sendPasswordResetEmail(),
                child: const Text(TText.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
