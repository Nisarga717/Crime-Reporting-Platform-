
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:live_crime_reporter/utils/constants/text_sizes.dart';
import '../theme/device_utility.dart';
import 'helperfunctions.dart';

class TAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TAppbar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingonPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: TextSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_left,color: THelperFunction.isDarkMode(context)?Colors.white:Colors.black),
        )
            : leadingIcon != null
            ? IconButton(
          onPressed: leadingonPressed,
          icon: Icon(leadingIcon),
        )
            : null,
        title: title,
        actions: actions,
      ),);

  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
