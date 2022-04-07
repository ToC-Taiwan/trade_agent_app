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

  /// `Targets`
  String get targets {
    return Intl.message(
      'Targets',
      name: 'targets',
      desc: '',
      args: [],
    );
  }

  /// `Strategy`
  String get strategy {
    return Intl.message(
      'Strategy',
      name: 'strategy',
      desc: '',
      args: [],
    );
  }

  /// `Pick Stock`
  String get pick_stock {
    return Intl.message(
      'Pick Stock',
      name: 'pick_stock',
      desc: '',
      args: [],
    );
  }

  /// `TSE`
  String get tse {
    return Intl.message(
      'TSE',
      name: 'tse',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
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

  /// `Stock Number`
  String get stock_number {
    return Intl.message(
      'Stock Number',
      name: 'stock_number',
      desc: '',
      args: [],
    );
  }

  /// `Delete All Pick Stock`
  String get delete_all_pick_stock {
    return Intl.message(
      'Delete All Pick Stock',
      name: 'delete_all_pick_stock',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete all pick stock?`
  String get delete_all_pick_stock_confirm {
    return Intl.message(
      'Are you sure you want to delete all pick stock?',
      name: 'delete_all_pick_stock_confirm',
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

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `No Pick Stock`
  String get no_pick_stock {
    return Intl.message(
      'No Pick Stock',
      name: 'no_pick_stock',
      desc: '',
      args: [],
    );
  }

  /// `Click + to add stock`
  String get click_plus_to_add_stock {
    return Intl.message(
      'Click + to add stock',
      name: 'click_plus_to_add_stock',
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
      Locale.fromSubtags(languageCode: 'zh'),
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
