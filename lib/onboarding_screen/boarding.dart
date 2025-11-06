import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/device_utility.dart';
import 'onboarding_controller.dart';
import 'onboarding_skip.dart';
import 'onboarding_widget.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen ({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());


    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.onboarding1,
                title: TText.onboardingtitle,
                subTitle: TText.onboarding1,
              ),
              OnBoardingPage(
                image: TImages.onboarding3,
                title: TText.onboardingtitle3,
                subTitle: TText.onboarding3,
              ),
              OnBoardingPage(
                image: TImages.onboarding2,
                title: TText.onboardingtitle2,
                subTitle: TText.onboarding2,
              ),
            ],
          ),
          Positioned(
            bottom: TDeviceUtils.getBottomNavigationBarHeight(context) + 25,
            right: TextSizes.defaultSpace,
            child: const OnBoardingSkip(),
          ),
          Positioned(
            right: TextSizes.defaultSpace,
            bottom: TDeviceUtils.getBottomNavigationBarHeight(context),
            child: ElevatedButton(
              onPressed: () => OnBoardingController.instance.nextPage(),
              style: ElevatedButton.styleFrom(shape: const CircleBorder()),
              child: const Icon(Iconsax.arrow_right_3),
            ),
          ),
        ],
      ),
    );
  }
}