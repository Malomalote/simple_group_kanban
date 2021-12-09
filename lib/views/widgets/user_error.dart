import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserError extends StatelessWidget {
  const UserError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No está registrado en la aplicación.',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text('Póngase en contacto con el administrador.',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            MaterialButton(
                child: const Text('Cerrar aplicación',
                    style: TextStyle(color: Colors.white)),
                color: Colors.blueAccent,
                onPressed: () =>
                    Future.delayed(const Duration(milliseconds: 400), () {
                      exit(0);
                    }))
          ],
        ),
      ),
    );
  }
}
