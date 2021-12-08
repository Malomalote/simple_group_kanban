import 'package:flutter/material.dart';
import 'package:nuid/nuid.dart';

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

  static String newNuid() {
    Nuid nuid = Nuid.instance;
    return nuid.next();
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
  const Color(0xFFffffff),
  const Color(0xFFf6f8f3),
  const Color(0xFFE8EDF1),
  const Color(0xFFF1FDEE),
  const Color(0xFFE7DDCC),
  const Color(0xFFD8E9DE),
  const Color(0xFFDFD5CE),
  const Color(0xFFE5D0C0),
  const Color(0xFFF5E0D8),
  const Color(0xFFE9F3F0),
  const Color(0xFFDEEBF0),
  const Color(0xFFF0E7F1),
  const Color(0xFFF8EDF5),
  const Color(0xFFE1EFF3),
  const Color(0xFFCBECF5),
  const Color(0xFFE2E9EB),
  const Color(0xFFDAE3E4),
  const Color(0xFFD7DDD8),
  const Color(0xFFD4F5EE),
  const Color(0xFFE0F1E6),
  const Color(0xFFF6E4D9),
  const Color(0xFFF8F1E0),
  const Color(0xFFF6F5E2),
  const Color(0xFFECEAE0),
  const Color(0xFFFFE9D7),
  const Color(0xFFFAD6C8),
  const Color(0xFFFAE6DD),
  const Color(0xFFFBE9DF),
  const Color(0xFFFAFAF2),
  const Color(0xFFFCF2E8),
  const Color(0xFFFEECE0),
];
