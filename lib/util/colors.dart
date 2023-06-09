import 'package:flutter/material.dart';

const primaryColor = Color(0xFF29AAE2);
const primaryColorDark = Color.fromARGB(255, 8, 127, 255);
const background = Color(0xFFFFFFFF);
const backgroundDark = Color(0xFFF2F0F0);
const textColorDark = Color(0xFF344D67);
const textColorLight = Color(0xFF6B728E);
const dividerColor = Color.fromARGB(255, 228, 223, 223);
const hintColor = Colors.grey;
const textFieldFillColor = Color(0xFFF5F5F5);

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
