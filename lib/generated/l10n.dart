// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Take a picture`
  String get takePicture {
    return Intl.message(
      'Take a picture',
      name: 'takePicture',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get chooseGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'chooseGallery',
      desc: '',
      args: [],
    );
  }

  /// `Filtering`
  String get filtering {
    return Intl.message(
      'Filtering',
      name: 'filtering',
      desc: '',
      args: [],
    );
  }

  /// `API keys`
  String get apiKeys {
    return Intl.message(
      'API keys',
      name: 'apiKeys',
      desc: '',
      args: [],
    );
  }

  /// `Add a filter`
  String get addFilter {
    return Intl.message(
      'Add a filter',
      name: 'addFilter',
      desc: '',
      args: [],
    );
  }

  /// `Filters name`
  String get nameFilter {
    return Intl.message(
      'Filters name',
      name: 'nameFilter',
      desc: '',
      args: [],
    );
  }

  /// `Filters url`
  String get urlFilter {
    return Intl.message(
      'Filters url',
      name: 'urlFilter',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Modifiy key`
  String get modifyKey {
    return Intl.message(
      'Modifiy key',
      name: 'modifyKey',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Modify filter`
  String get modifyFilter {
    return Intl.message(
      'Modify filter',
      name: 'modifyFilter',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Use information`
  String get usageInformation {
    return Intl.message(
      'Use information',
      name: 'usageInformation',
      desc: '',
      args: [],
    );
  }

  /// `This app uses Google Vision ai API and Google Custom Search. Please add your API keys in settings`
  String get usageInformationMessage {
    return Intl.message(
      'This app uses Google Vision ai API and Google Custom Search. Please add your API keys in settings',
      name: 'usageInformationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cannot open the link`
  String get cannotOpenLink {
    return Intl.message(
      'Cannot open the link',
      name: 'cannotOpenLink',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during the search. Please check your API keys and connection`
  String get errorUserInfo {
    return Intl.message(
      'An error occurred during the search. Please check your API keys and connection',
      name: 'errorUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `No results found.`
  String get noResultInfo {
    return Intl.message(
      'No results found.',
      name: 'noResultInfo',
      desc: '',
      args: [],
    );
  }

  /// `Please restart the application after changing this information`
  String get updateKeysInfo {
    return Intl.message(
      'Please restart the application after changing this information',
      name: 'updateKeysInfo',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
