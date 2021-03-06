import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:simple_kanban/controllers/board_provider.dart';
import 'package:simple_kanban/controllers/menu_provider.dart';
import 'package:simple_kanban/utils/utils.dart';
import 'package:simple_kanban/views/widgets/dialogs/custom_about_dialog.dart';
import 'package:simple_kanban/views/widgets/dialogs/delete_user_dialog.dart';
import 'package:simple_kanban/views/widgets/dialogs/new_user_dialog.dart';
import 'package:simple_kanban/views/widgets/dialogs/state_card_dialog.dart';
import 'package:simple_kanban/views/widgets/dialogs/update_user_dialog.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MenuProvider menuProvider = Provider.of<MenuProvider>(context);
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    return Container(
      width: menuProvider.menuWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          GestureDetector(
            child: const Icon(Icons.menu_open),
            onTap: () {
              menuProvider.switchMenu();
            },
          ),
          if (boardProvider.currentUserRol == UsersRol.admin)
            const _AdminMenu(),
          _MenuItem(
            icon: Icons.auto_awesome_motion,
            text: 'Añadir Categoría',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const StateCardDialog());
            },
          ),
          const Divider(),
          _MenuItem(
            icon: FontAwesomeIcons.question,
            text: 'About...',
            font: 'FaIcon',
            onPressed: () {
              showDialog(
                  context: context, builder: (_) => const CustomAboutDialog());
            },
          ),
        ],
      ),
    );
  }
}

class _AdminMenu extends StatelessWidget {
  const _AdminMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.person_add,
          text: 'Añadir Usuario',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => const NewUserDialog(),
            );
          },
        ),
        _MenuItem(
            icon: Icons.manage_accounts,
            text: 'Editar Usuario',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => const UpdateUserDialog(),
              );
            }),
        _MenuItem(
          icon: Icons.person_off,
          text: 'Borrar Usuario',
          onPressed: () {
            showDialog(
                context: context, builder: (_) => const DeleteUserDialog());
          },
        ),
        const Divider(),
        _MenuItem(
          icon: Icons.group_add,
          text: 'Añadir Equipo',
          onPressed: () {
            print('añadir equipo');
          },
        ),
        _MenuItem(
          icon: FontAwesomeIcons.usersCog,
          font: 'FaIcon',
          text: 'Editar Equipo',
          onPressed: () {
            print('editar equipo');
          },
        ),
        _MenuItem(
          icon: FontAwesomeIcons.usersSlash,
          font: 'FaIcon',
          text: 'Borrar Equipo',
          onPressed: () {
            print('borrar equipo');
          },
        ),
        Divider(),
      ],
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final String? font;
  const _MenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.font,
  }) : super(key: key);

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  Color backgroundColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    final MenuProvider menuProvider = Provider.of<MenuProvider>(context);
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
                const SizedBox(width: 8),
                Tooltip(
                  textStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  height: 40,
                  message: (!menuProvider.expand) ? widget.text : '',
                  child:
                      Icon(widget.icon, size: (widget.font != null) ? 20 : 25),
                ),
                const SizedBox(width: 10),
                if (menuProvider.expand)
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
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
