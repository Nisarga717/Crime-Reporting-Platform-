import 'package:flutter/material.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/theme/device_utility.dart';
import 'onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TextSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text(
          'Skip',
          style: TextStyle(color: Colors.lightGreen),
        ),
      ),
    );
  }
}



