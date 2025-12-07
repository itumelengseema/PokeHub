import 'package:flutter/material.dart';
import '../../utils/responsive/screen_breakpoints.dart';
import '../../utils/responsive/responsive_size.dart';

/// Callback type for building widgets based on device type
typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  DeviceType deviceType,
  ResponsiveSize size,
);


class ResponsiveBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveSize(context);
    return builder(context, size.deviceType, size);
  }
}


class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, size) {
        switch (deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}


class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveSize(context);

    return Container(
      color: color,
      decoration: decoration,
      child: Center(
        child: Container(
          width: size.contentWidth,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: size.contentPaddingHorizontal,
              ),
          child: child,
        ),
      ),
    );
  }
}


extension ResponsiveContext on BuildContext {
  ResponsiveSize get responsive => ResponsiveSize(this);

  DeviceType get deviceType => responsive.deviceType;
  ScreenSize get screenSize => responsive.screenSize;
  OrientationType get orientation => responsive.orientation;

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  bool get isPortrait => responsive.isPortrait;
  bool get isLandscape => responsive.isLandscape;
}
