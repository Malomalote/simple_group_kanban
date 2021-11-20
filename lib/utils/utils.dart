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

  static String newNuid(){
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




    const Color(0xFFE6E8E3),
    const Color(0xFFACC9E9),
    const Color(0xFFBCDDB0),
    const Color(0xFFFFE4B5),
    const Color(0xFFADD0BA),
    const Color(0xFFCEC1B8),
    const Color(0xFFF3CEB3),
    const Color(0xFFF9C2AD),
    const Color(0xFFB9BDBC),
    const Color(0xFFBAD5E0),
    const Color(0xFFECE2ED),
    const Color(0xFFF8EDF5),
    const Color(0xFFBCDEE8),
    const Color(0xFFCBECF5),
    const Color(0xFF7FC7D5),
    const Color(0xFFCAE9EB),
    const Color(0xFFBBDFC1),
    const Color(0xFFC5E6DF),
    const Color(0xFFCEE9D8),
    const Color(0xFFFDCAAD),
    const Color(0xFFFFE8B6),
    const Color(0xFFFFF6A7),
    const Color(0xFFFDFACF),
    const Color(0xFFFFF8DC),
    const Color(0xFFE5CAB5),
    const Color(0xFFD5B5A8),
    const Color(0xFFFBBAA4),
    const Color(0xFFFDE1D4),
    const Color(0xFFDCCDB0),
    const Color(0xFFDBDBCF),
    const Color(0xFFF1DDC5),
    const Color(0xFFFEECE0),
    const Color(0xFFFFF0CF),
    const Color(0xFFFCF2E8),
    const Color(0xFFFEDEC7),
    const Color(0xFFFEF1E1),
    const Color(0xFFFDCBB2),
    const Color(0xFFFADBC9),
    const Color(0xFFFBCFC2),
    const Color(0xFFFBE9DF),
];