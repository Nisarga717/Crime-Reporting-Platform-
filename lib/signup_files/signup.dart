import 'package:flutter/material.dart';
import 'package:live_crime_reporter/signup_files/signupform.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/helperfunctions.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/constants/text_strings.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key,});

  @override

  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TextSizes.defaultSpace),
          child: Column(
            children: [
              Text(
                TText.signuptitles,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TextSizes.spaceBtwItems),
              TSignupform(dark: dark),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.containerDark),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: IconButton(
                      onPressed: () {},
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
                      onPressed: () {},
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

