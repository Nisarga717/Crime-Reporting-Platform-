import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class VChipTheme{
  VChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: TColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color:TColors.black),
    selectedColor: TColors.secondaryColor,
    padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
    checkmarkColor: TColors.white,


  );
  static ChipThemeData DarkChipTheme = ChipThemeData(
    disabledColor: TColors.darkgrey,
    labelStyle: const TextStyle(color:TColors.white),
    selectedColor: TColors.secondaryColor,
    padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
    checkmarkColor: TColors.white,
  );
}