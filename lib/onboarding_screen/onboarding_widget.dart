import 'package:flutter/material.dart';

import '../../utils/constants/helperfunctions.dart';
import '../../utils/constants/text_sizes.dart';



class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Image(
            width: THelperFunction.screenWidth(context) * 0.8,
            height: THelperFunction.screenHeight(context) * 0.6,
            image: AssetImage(image),
          ),
          const SizedBox(height: TextSizes.spaceBtwItems),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TextSizes.spaceBtwItems),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}