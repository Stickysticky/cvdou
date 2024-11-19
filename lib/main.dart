import 'package:flutter/material.dart';
import 'package:cvdou/pages/home.dart';
import 'package:cvdou/pages/settingsPage.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/settings': (context) => SettingsPage(),
    },
  ));
}
