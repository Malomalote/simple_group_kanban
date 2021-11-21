import 'package:flutter/material.dart';
import 'package:simple_kanban/views/widgets/custom_alert_title.dart';

class AboutDialog extends StatelessWidget {
  const AboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            contentPadding: const EdgeInsets.all(8),
      buttonPadding: const EdgeInsets.all(15),
      title: const CustomAlertTitle(title: 'Acerca de Simple Kanban'),
      content: _AboutContent(),
            actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),]
      
    )
    
    ;
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Versión 0.1'),
        Text('Autor: Antonio M. García Gómez'),
        Text('Contacto: antoniomigueldev@gmail.com'),
      ],
    );
  }
}