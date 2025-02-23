

import 'package:cvdou/generated/l10n.dart';
import 'package:cvdou/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const MaterialApp MATERIAL_APP_WIDGET_CONST =
  MaterialApp(
    locale: const Locale('fr'),
    supportedLocales: const [Locale('fr', '')],
    localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    S.delegate,
    ],
    home: const Home(),
  );