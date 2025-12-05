import 'package:flutter/material.dart';
import 'screen_breakpoints.dart';


class ResponsiveSize {
  final BuildContext context;
  late final double _screenWidth;
  late final double _screenHeight;
  late final DeviceType _deviceType;
  late final ScreenSize _screenSize;
  late final OrientationType _orientation;

  ResponsiveSize(this.context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _deviceType = ScreenBreakpoints.getDeviceType(_screenWidth);
    _screenSize = ScreenBreakpoints.getScreenSize(_screenWidth);
    _orientation = mediaQuery.orientation == Orientation.portrait
        ? OrientationType.portrait
        : OrientationType.landscape;
  }

  // Getters for screen properties
  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;
  DeviceType get deviceType => _deviceType;
  ScreenSize get screenSize => _screenSize;
  OrientationType get orientation => _orientation;


  bool get isMobile => _deviceType == DeviceType.mobile;
  bool get isTablet => _deviceType == DeviceType.tablet;
  bool get isDesktop => _deviceType == DeviceType.desktop;


  bool get isPortrait => _orientation == OrientationType.portrait;
  bool get isLandscape => _orientation == OrientationType.landscape;

  double scaleWidth(double size) {
    const baseWidth = 360.0;
    return (size / baseWidth) * _screenWidth;
  }

 
  double scaleHeight(double size) {
    const baseHeight = 640.0;
    return (size / baseHeight) * _screenHeight;
  }


  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (_deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }


  T responsiveValueBySize<T>({
    required T small,
    T? medium,
    T? large,
    T? extraLarge,
  }) {
    switch (_screenSize) {
      case ScreenSize.small:
        return small;
      case ScreenSize.medium:
        return medium ?? small;
      case ScreenSize.large:
        return large ?? medium ?? small;
      case ScreenSize.extraLarge:
        return extraLarge ?? large ?? medium ?? small;
    }
  }


  int get gridColumns => ScreenBreakpoints.getGridColumns(_deviceType);


  EdgeInsets responsivePadding({
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.all(value);
  }

  
  EdgeInsets responsiveHorizontalPadding({
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.symmetric(horizontal: value);
  }


  EdgeInsets responsiveVerticalPadding({
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      mobile: mobile ?? 16.0,
      tablet: tablet ?? 24.0,
      desktop: desktop ?? 32.0,
    );
    return EdgeInsets.symmetric(vertical: value);
  }


  double get contentWidth {
    if (isDesktop && _screenWidth > ScreenBreakpoints.maxContentWidth) {
      return ScreenBreakpoints.maxContentWidth;
    }
    return _screenWidth;
  }


  double get contentPaddingHorizontal {
    if (isDesktop && _screenWidth > ScreenBreakpoints.maxContentWidth) {
      return (_screenWidth - ScreenBreakpoints.maxContentWidth) / 2;
    }
    return 0;
  }
}
