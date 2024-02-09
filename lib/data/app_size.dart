import 'package:flutter/material.dart';

double screenWidth(double size, BuildContext context) {
  return (MediaQuery.of(context).size.width / 360) * size;
}

double screenHeight(double size, BuildContext context) {
  return (MediaQuery.of(context).size.height / 800) * size;
}

class AppSize {
  static const h8 = SizedBox(
    height: 8,
  );
  static const h16 = SizedBox(
    height: 16,
  );
  static const w16 = SizedBox(
    width: 16,
  );
  static const w8 = SizedBox(
    width: 8,
  );
}
