import 'package:flutter/material.dart';
import 'package:cvdou/pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
    },
  ));
}
