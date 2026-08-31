import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 16;
    }

    if (width < 1024) {
      return 28;
    }

    return 50;
  }

  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 1;
    }

    if (width < 900) {
      return 2;
    }

    if (width < 1200) {
      return 3;
    }

    return 4;
  }

  static double titleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return 30;
    }

    if (width < 1024) {
      return 36;
    }

    return 42;
  }
}