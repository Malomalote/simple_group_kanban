import 'package:flutter/material.dart';

enum CardDirection { izquierda, derecha }

class Utils {
  static bool isDNI(String dni) {
    if (dni.length != 9) return false;
    const String _dniNieRegex = "^[XYZ]?[0-9]{7,8}[A-Z]{1}\$";
    if (!RegExp(_dniNieRegex).hasMatch(dni.toUpperCase())) return false;
    const letters = 'TRWAGMYFPDXBNJZSQVHLCKET';
    String dniNumber;
    String dniLetter;
    dniNumber = dni.substring(0, dni.length - 1).toUpperCase();
    dniLetter = dni.substring(dni.length - 1).toUpperCase();
    if (dniNumber.startsWith('X')) dniNumber = dniNumber.replaceFirst('X', '0');
    if (dniNumber.startsWith('Y')) dniNumber = dniNumber.replaceFirst('Y', '1');
    if (dniNumber.startsWith('Z')) dniNumber = dniNumber.replaceFirst('Z', '2');
    final pos = int.parse(dniNumber) % 23;
    return dniLetter == letters[pos];
  }

  static int colorToInt(Color color) {
    String colorString = color.toString(); // Color(0x12345678)
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    return int.parse(valueString, radix: 16);
  }

  static Color intToColor(int value) {
    return Color(value);
  }
}
