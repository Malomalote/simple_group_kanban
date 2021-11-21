import 'package:flutter/material.dart';

class CustomAlertTitle extends StatelessWidget {
  final String title;
  const CustomAlertTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const Divider(height: 10, thickness: 3,color: Colors.black38,),
      ],
    );
  }
}
