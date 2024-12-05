import 'package:flutter/material.dart';
import 'package:cvdou/pages/home.dart';
import 'package:cvdou/pages/settingsPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cvdou/generated/l10n.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      //'/home': (context) => Home(key: UniqueKey()),
      '/home': (context) => Home(),
      '/settings': (context) => SettingsPage(),
    },
    locale: Locale('fr'),
    supportedLocales: [
      Locale('fr', ''),
    ],
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      S.delegate
    ],
    localeResolutionCallback: (locale, supportedLocales) {
      if (locale == null) {
        return Locale('fr');  // Par défaut "fr"
      }
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return supportedLocale;
        }
      }
      return Locale('fr');  // Par défaut "fr"
    },
  ));
}
