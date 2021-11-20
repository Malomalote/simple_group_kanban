import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:provider/provider.dart';

import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/menu_provider.dart';
import 'package:simple_kanban/views/widgets/state_card_dialog.dart';

class LeftMenu extends StatefulWidget {
  const LeftMenu({Key? key}) : super(key: key);

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    return Container(
      width: MenuProvider.menuWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          GestureDetector(
            child: Icon(Icons.menu_open),
            onTap: () {
              MenuProvider.switchMenu();
              setState(() {});
            },
          ),
          if (boardProvider.currentUserRol == 'Administrador') _AdminMenu(),
          _MenuItem(
              icon: Icons.auto_awesome_motion,
              text: 'Añadir Categoría',
              onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  StateCardDialog());
                
              })
        ],
      ),
    );
  }
}

class _AdminMenu extends StatelessWidget {
  const _AdminMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.person_add,
            text: 'Añadir Usuario',
            onPressed: () {
              print('añadir usuario');
            },
          ),
          _MenuItem(
            icon: Icons.manage_accounts,
            text: 'Editar Usuario',
            onPressed: () {
              print('editar usuario');
            },
          ),
          _MenuItem(
            icon: Icons.person_off,
            text: 'Borrar Usuario',
            onPressed: () {
              print('borrar usuario');
            },
          ),
          Text('uno'),
          Text('dos'),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  const _MenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  Color backgroundColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onHover: _changeColor,
        onExit: _whiteColor,
        child: Container(
          color: backgroundColor,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Row(
              children: [
                SizedBox(width: 8),
                Tooltip(

                  textStyle: TextStyle(fontSize: 15,color: Colors.white),
                  height: 40,
                  message: (!MenuProvider.expand) ? widget.text:'',
                  child: Icon(widget.icon),
                ),
                SizedBox(width: 8),
                if (MenuProvider.expand)
                  Text(widget.text,
                      style: TextStyle(
                        fontSize: 16,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeColor(PointerHoverEvent event) {
    setState(() {
      backgroundColor = Colors.grey;
    });
  }

  void _whiteColor(PointerExitEvent event) {
    setState(() {
      backgroundColor = Colors.white;
    });
  }
}
