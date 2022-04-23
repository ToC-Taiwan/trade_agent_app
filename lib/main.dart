import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/firebase_options.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/intro.dart';
import 'package:trade_agent_v2/models/basic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // adsense
  await MobileAds.instance.initialize();
  if (kDebugMode) {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ['kGADSimulatorID'],
      ),
    );
  }

  // initital floor
  // final db = await $FloorAppDatabase.databaseBuilder('app_database_tr.db').addMigrations([migration1to2]).build();
  final db = await $FloorAppDatabase.databaseBuilder('app_database_tr.db').build();
  var version = await db.basicDao.getBasicByKey('version');
  if (version == null) {
    await db.basicDao.insertBasic(Basic('version', '3.0.0'));
  }

  var dbLanguageSetup = await db.basicDao.getBasicByKey('language_setup');
  if (dbLanguageSetup == null) {
    final defaultLocale = Platform.localeName;
    Basic tmp;
    var splitLocale = defaultLocale.split('_');
    if (splitLocale[0] == 'zh' && splitLocale[1] == 'Hant') {
      tmp = Basic('language_setup', 'zh_Hant');
    } else if (splitLocale[0] == 'zh' && splitLocale[1] == 'Hans') {
      tmp = Basic('language_setup', 'zh_Hans');
    } else {
      tmp = Basic('language_setup', 'en');
    }
    await db.basicDao.insertBasic(tmp);
    dbLanguageSetup = tmp;
  }

  runApp(
    MyApp(
      dbLanguageSetup.value,
      db: db,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp(this.languageSetup, {Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  final String languageSetup;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String language;
  late String languageScript;
  late String country;
  late Locale locale;

  @override
  void initState() {
    var splitLanguage = widget.languageSetup.split('_');
    if (splitLanguage[0].isNotEmpty) {
      language = splitLanguage[0];
    } else {
      language = 'en';
    }
    if (splitLanguage.length == 2 && splitLanguage[1].isNotEmpty) {
      languageScript = splitLanguage[1];
    } else {
      languageScript = '';
    }
    if (splitLanguage.length == 3 && splitLanguage[2].isNotEmpty) {
      country = splitLanguage[2];
    } else {
      country = '';
    }

    if (languageScript.isNotEmpty && country.isNotEmpty) {
      locale = Locale.fromSubtags(languageCode: language, countryCode: country, scriptCode: languageScript);
    } else if (languageScript.isNotEmpty && country.isEmpty) {
      locale = Locale.fromSubtags(languageCode: language, scriptCode: languageScript);
    } else if (languageScript.isEmpty && country.isNotEmpty) {
      locale = Locale.fromSubtags(languageCode: language, countryCode: country);
    } else {
      locale = Locale.fromSubtags(languageCode: language);
    }
    super.initState();
  }

  void hideKeyboard(BuildContext context) {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color.fromARGB(255, 255, 255, 255)),
      ),
      home: IntroPage(
        db: widget.db,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) => Scaffold(
        // Global GestureDetector that will dismiss the keyboard
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  var swatch = <int, Color>{};

  final r = color.red;
  final g = color.green;
  final b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[((strength as double) * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
