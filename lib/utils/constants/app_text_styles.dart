import 'package:flutter/material.dart';


class AppTextStyles {
  
  AppTextStyles._();

 
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 13.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSizeXxl = 20.0;
  static const double fontSizeHuge = 24.0;
  static const double fontSizeMassive = 28.0;
  static const double fontSizeGiant = 32.0;


  static const TextStyle displayLarge = TextStyle(
    fontSize: fontSizeGiant,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: fontSizeMassive,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: fontSizeHuge,
    fontWeight: FontWeight.bold,
  );


  static const TextStyle headingLarge = TextStyle(
    fontSize: fontSizeXxl,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.bold,
  );

  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: FontWeight.normal,
  );

 
  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: FontWeight.w500,
  );

  
  static const TextStyle caption = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: FontWeight.normal,
  );

 
  static const TextStyle button = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: FontWeight.bold,
  );


  static TextStyle scaleTextStyle(TextStyle baseStyle, double scaleFactor) {
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? fontSizeMd) * scaleFactor,
    );
  }
}
