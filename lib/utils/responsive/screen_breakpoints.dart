enum DeviceType {
  mobile,
  tablet,
  desktop,
}


enum ScreenSize {
  small,
  medium,
  large,
  extraLarge,
}


enum OrientationType {
  portrait,
  landscape,
}


class ScreenBreakpoints {
  
  ScreenBreakpoints._();

 
  static const double mobileMaxWidth = 600.0;
  static const double tabletMaxWidth = 1024.0;
  static const double desktopMinWidth = 1024.0;


  static const double smallMaxWidth = 360.0;
  static const double mediumMaxWidth = 600.0;
  static const double largeMaxWidth = 1024.0;


 
  static const int mobileColumns = 2;
  static const int tabletColumns = 3;
  static const int desktopColumns = 4;


  static const double maxContentWidth = 1440.0;

  
  static DeviceType getDeviceType(double width) {
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  
  static ScreenSize getScreenSize(double width) {
    if (width < smallMaxWidth) {
      return ScreenSize.small;
    } else if (width < mediumMaxWidth) {
      return ScreenSize.medium;
    } else if (width < largeMaxWidth) {
      return ScreenSize.large;
    } else {
      return ScreenSize.extraLarge;
    }
  }

 
  static int getGridColumns(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobileColumns;
      case DeviceType.tablet:
        return tabletColumns;
      case DeviceType.desktop:
        return desktopColumns;
    }
  }
}
