import 'package:flutter/material.dart';

InputDecoration CustomInputDecoration(
    {required String hintText,
    required String labelText,
    required TextEditingController controller,
    required VoidCallback onTap}) {
  return InputDecoration(
      hintText: hintText,
      suffixIcon: GestureDetector(
          child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.clear_rounded, color: Colors.grey, size: 14)),
          onTap: onTap
          ,),
      labelText: labelText,
      hintStyle: const TextStyle(fontSize: 10));
}
