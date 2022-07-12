import 'package:flutter/material.dart';

const Color colorPrimaryRedCaramelDark = Color(0xFF7A370B);
const Color colorPrimaryRedCaramel = Color(0xFF864921);
const Color colorSecondaryGreenPlant = Color(0xFF4D6658);
const Color colorSurfaceSmoothGreenPlant = Color(0xFFFBFDF7);
const Color colorPrimaryLightRedCaramel = Color(0xFFF2EEE1);
const Color colorSecondaryLightGreenPlant = Color(0xFFE9F1E8);
const Color colorTextSmoothBlack = Color(0xFF49454F);

const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: colorPrimaryRedCaramel,
  onPrimary: colorPrimaryRedCaramelDark,
  secondary: colorSecondaryGreenPlant,
  onSecondary: colorSecondaryLightGreenPlant,
  surface: colorSurfaceSmoothGreenPlant,
  onSurface: colorPrimaryLightRedCaramel,
  error: colorPrimaryLightRedCaramel,
  onError: colorPrimaryRedCaramel,
  background: colorSurfaceSmoothGreenPlant,
  onBackground: colorPrimaryLightRedCaramel,
);
