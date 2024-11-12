import 'package:flutter/material.dart';

class SearchBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const SearchBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue.shade600,
      ),
      child: Text(
        "Rechercher",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
