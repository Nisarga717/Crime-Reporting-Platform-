import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:live_crime_reporter/signup_files/verify_email.dart';
import 'package:live_crime_reporter/signup_files/signup_controller.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/constants/validators.dart';

class TSignupform extends StatelessWidget {
  const TSignupform({
    super.key,
    required this.dark,
    this.controller,
  });

  final TextEditingController? controller;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Firstname', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TText.firstname,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TextSizes.spaceBtwItems),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Lastname', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TText.lastname,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // Address Field
          TextFormField(
            controller: controller.address,
            validator: (value) =>
                TValidator.validateEmptyText('Address', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: 'Address',
              prefixIcon: Icon(Iconsax.location),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // Pincode Field
          TextFormField(
            controller: controller.pincode,
            validator: (value) =>
                TValidator.validateEmptyText('Pincode', value),
            expands: false,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Pincode',
              prefixIcon: Icon(Iconsax.location),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // State Text Field
          TextFormField(
            controller: controller.state,
            validator: (value) => TValidator.validateEmptyText('State', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: 'State',
              prefixIcon: Icon(Iconsax.map),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // City Text Field
          TextFormField(
            controller: controller.city,
            validator: (value) => TValidator.validateEmptyText('City', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: 'City',
              prefixIcon: Icon(Iconsax.location),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // Email Field
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: TText.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // Phone Number Field
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            expands: false,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: TText.phonenumber,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // Language Field
          TextFormField(
            controller: controller.language,
            validator: (value) =>
                TValidator.validateEmptyText('Language', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: 'Language',
              prefixIcon: Icon(Iconsax.book),
            ),
          ),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),

          // Password Field
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              expands: false,
              obscureText: controller.hidepassword.value,
              decoration: InputDecoration(
                labelText: TText.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidepassword.value = !controller.hidepassword.value,
                  icon: Icon(controller.hidepassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),

          TermsandCondition(dark: dark),
          const SizedBox(height: TextSizes.spaceBtwInputfeilds),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(TText.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}

class TermsandCondition extends StatelessWidget {
  const TermsandCondition({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
              value: controller.privacypolicy.value,
              onChanged: (value) => controller.privacypolicy.value = !controller.privacypolicy.value)),
        ),
        const SizedBox(width: TextSizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: TText.iagreeto,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: TText.privatepolicy,
                style: Theme.of(context).textTheme.bodyMedium?.apply(
                      color:
                          dark ? TColors.textSecondary : TColors.secondaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          dark ? TColors.textSecondary : TColors.secondaryColor,
                    ),
              ),
              TextSpan(
                text: TText.and,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: TText.Termsofuse,
                style: Theme.of(context).textTheme.bodyMedium?.apply(
                      color:
                          dark ? TColors.textSecondary : TColors.secondaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          dark ? TColors.textSecondary : TColors.secondaryColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}