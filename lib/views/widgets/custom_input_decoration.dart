  import 'package:flutter/material.dart';

InputDecoration CustomInputDecoration(
      {required String hintText,
      required String labelText,
      required TextEditingController controller}) {
    return InputDecoration(
        hintText: hintText,
        suffixIcon: GestureDetector(
            child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(Icons.clear_rounded,
                    color: Colors.grey, size: 14)),
            onTap: () {
              controller.text = '';
            }),
        labelText: labelText,
        hintStyle: const TextStyle(fontSize: 10));
  }