import 'package:flutter/material.dart';

class SearchBtn extends StatefulWidget {
  final VoidCallback onPressed;

  SearchBtn({Key? key, required this.onPressed}) : super(key: key);

  @override
  _SearchBtnState createState() => _SearchBtnState();
}

class _SearchBtnState extends State<SearchBtn> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null :
          () async {
        setState(() {
          _isLoading = true;
        });
        widget.onPressed();
        setState(() {
          _isLoading = false;
        });
      },
      style: ButtonStyle(
        // Color change based on loading state
        backgroundColor: _isLoading
            ? WidgetStateProperty.all<Color>(Colors.grey)
            : WidgetStateProperty.all<Color>(Colors.lightBlue.shade600),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
        "Rechercher",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
