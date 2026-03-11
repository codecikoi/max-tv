import 'package:flutter/material.dart';

class AppImages {
  static const _base = 'assets/images';

  static Image png(
    String name, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      '$_base/$name.png',
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Image webp(
    String name, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      '$_base/$name.webp',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
