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

List<Color> kanbanColors = [




    Color(0xFFE6E8E3),
    Color(0xFFACC9E9),
    Color(0xFFBCDDB0),
    Color(0xFFFFE4B5),
    Color(0xFFADD0BA),
    Color(0xFFCEC1B8),
    Color(0xFFF3CEB3),
    Color(0xFFF9C2AD),
    Color(0xFFB9BDBC),
    Color(0xFFBAD5E0),
    Color(0xFFECE2ED),
    Color(0xFFF8EDF5),
    Color(0xFFBCDEE8),
    Color(0xFFCBECF5),
    Color(0xFF7FC7D5),
    Color(0xFFCAE9EB),
    Color(0xFFBBDFC1),
    Color(0xFFC5E6DF),
    Color(0xFFCEE9D8),
    Color(0xFFFDCAAD),
    Color(0xFFFFE8B6),
    Color(0xFFFFF6A7),
    Color(0xFFFDFACF),
    Color(0xFFFFF8DC),
    Color(0xFFE5CAB5),
    Color(0xFFD5B5A8),
    Color(0xFFFBBAA4),
    Color(0xFFFDE1D4),
    Color(0xFFDCCDB0),
    Color(0xFFDBDBCF),
    Color(0xFFF1DDC5),
    Color(0xFFFEECE0),
    Color(0xFFFFF0CF),
    Color(0xFFFCF2E8),
    Color(0xFFFEDEC7),
    Color(0xFFFEF1E1),
    Color(0xFFFDCBB2),
    Color(0xFFFADBC9),
    Color(0xFFFBCFC2),
    Color(0xFFFBE9DF),
];