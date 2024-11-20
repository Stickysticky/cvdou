import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String _title = 'CVdOU';
  final Color _backgroundColor = Colors.lightBlue.shade600;
  final Color _titleColor = Colors.white;
  final double _fontSize = 30;

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      centerTitle: true,
      backgroundColor: _backgroundColor,
      titleTextStyle: TextStyle(
          color: _titleColor,
          fontSize: _fontSize
      ),
        iconTheme: IconThemeData(color: _titleColor),
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: _titleColor),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

}