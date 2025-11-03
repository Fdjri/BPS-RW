import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const RedColors red = RedColors();
  static const GreenColors green = GreenColors();
  static const YellowColors yellow = YellowColors();
  static const BlueColors blue = BlueColors();
  static const BlackColors black = BlackColors();
  static const WhiteColors white = WhiteColors();
}

// --- RED ---
class RedColors {
  const RedColors();

  // Light
  final Color light = const Color.fromRGBO(253, 238, 233, 1);
  final Color lightHover = const Color.fromRGBO(252, 230, 222, 1);
  final Color lightActive = const Color.fromRGBO(249, 204, 187, 1);

  // Normal
  final Color normal = const Color.fromRGBO(236, 89, 37, 1);
  final Color normalHover = const Color.fromRGBO(212, 80, 33, 1);
  final Color normalActive = const Color.fromRGBO(189, 71, 30, 1);

  // Dark
  final Color dark = const Color.fromRGBO(177, 67, 28, 1);
  final Color darkHover = const Color.fromRGBO(142, 53, 22, 1);
  final Color darkActive = const Color.fromRGBO(106, 40, 17, 1);

  // Darker
  final Color darker = const Color.fromRGBO(83, 31, 13, 1);
}

// --- GREEN ---
class GreenColors {
  const GreenColors();

  // Light
  final Color light = const Color.fromRGBO(230, 244, 237, 1);
  final Color lightHover = const Color.fromRGBO(217, 239, 227, 1);
  final Color lightActive = const Color.fromRGBO(176, 221, 198, 1);

  // Normal
  final Color normal = const Color.fromRGBO(0, 146, 71, 1);
  final Color normalHover = const Color.fromRGBO(0, 131, 64, 1);
  final Color normalActive = const Color.fromRGBO(0, 117, 57, 1);

  // Dark
  final Color dark = const Color.fromRGBO(0, 110, 53, 1);
  final Color darkHover = const Color.fromRGBO(0, 88, 43, 1);
  final Color darkActive = const Color.fromRGBO(0, 66, 32, 1);

  // Darker
  final Color darker = const Color.fromRGBO(0, 51, 25, 1);
}

// --- YELLOW ---
class YellowColors {
  const YellowColors();

  // Light
  final Color light = const Color.fromRGBO(255, 249, 233, 1);
  final Color lightHover = const Color.fromRGBO(254, 245, 222, 1);
  final Color lightActive = const Color.fromRGBO(254, 235, 187, 1);

  // Normal
  final Color normal = const Color.fromRGBO(251, 191, 36, 1);
  final Color normalHover = const Color.fromRGBO(226, 172, 32, 1);
  final Color normalActive = const Color.fromRGBO(201, 153, 29, 1);
  
  // Dark
  final Color dark = const Color.fromRGBO(188, 143, 27, 1);
  final Color darkHover = const Color.fromRGBO(151, 115, 22, 1);
  final Color darkActive = const Color.fromRGBO(113, 86, 16, 1);

  // Darker
  final Color darker = const Color.fromRGBO(88, 67, 13, 1);
}

// --- BLUE ---
class BlueColors {
  const BlueColors();

  // Light
  final Color light = const Color.fromRGBO(237, 244, 245, 1);
  final Color lightHover = const Color.fromRGBO(229, 238, 240, 1);
  final Color lightActive = const Color.fromRGBO(200, 220, 223, 1);

  // Normal
  final Color normal = const Color.fromRGBO(79, 141, 152, 1);
  final Color normalHover = const Color.fromRGBO(71, 127, 137, 1);
  final Color normalActive = const Color.fromRGBO(63, 113, 122, 1);

  // Dark
  final Color dark = const Color.fromRGBO(59, 106, 114, 1);
  final Color darkHover = const Color.fromRGBO(47, 85, 91, 1);
  final Color darkActive = const Color.fromRGBO(36, 63, 68, 1);

  // Darker
  final Color darker = const Color.fromRGBO(28, 49, 53, 1);
}

// --- BLACK ---
class BlackColors {
  const BlackColors();

  // Light
  final Color light = const Color.fromRGBO(230, 230, 230, 1);
  final Color lightHover = const Color.fromRGBO(217, 217, 217, 1);
  final Color lightActive = const Color.fromRGBO(176, 176, 176, 1);

  // Normal
  final Color normal = const Color.fromRGBO(0, 0, 0, 1);
  final Color normalHover = const Color.fromRGBO(0, 0, 0, 1);
  final Color normalActive = const Color.fromRGBO(0, 0, 0, 1);

  // Dark
  final Color dark = const Color.fromRGBO(0, 0, 0, 1);
  final Color darkHover = const Color.fromRGBO(0, 0, 0, 1);
  final Color darkActive = const Color.fromRGBO(0, 0, 0, 1);

  // Darker
  final Color darker = const Color.fromRGBO(0, 0, 0, 1);
}

// --- WHITE ---
class WhiteColors {
  const WhiteColors();

  // Light
  final Color light = const Color.fromRGBO(255, 255, 255, 1);
  final Color lightHover = const Color.fromRGBO(255, 255, 255, 1);
  final Color lightActive = const Color.fromRGBO(255, 255, 255, 1);

  // Normal
  final Color normal = const Color.fromRGBO(255, 255, 255, 1);
  final Color normalHover = const Color.fromRGBO(230, 230, 230, 1);
  final Color normalActive = const Color.fromRGBO(204, 204, 204, 1);

  // Dark
  final Color dark = const Color.fromRGBO(191, 191, 191, 1);
  final Color darkHover = const Color.fromRGBO(153, 153, 153, 1);
  final Color darkActive = const Color.fromRGBO(115, 115, 115, 1);

  // Darker
  final Color darker = const Color.fromRGBO(89, 89, 89, 1);
}