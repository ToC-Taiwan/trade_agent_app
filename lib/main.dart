// import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trade_agent_app/balance.dart';
import 'package:trade_agent_app/targets.dart';
import 'package:trade_agent_app/order.dart';
import 'package:trade_agent_app/settings.dart';
import 'package:trade_agent_app/tse.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  MobileAds.instance.initialize();
  // MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ['E6FC92ABFEC4D54CB0FF4F8AB8EF1AD4']));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Trade Agent'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Can't show a dialog in initState, delaying initialization
  //   WidgetsBinding.instance!.addPostFrameCallback((_) => initPlugin());
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlugin() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  //   // If the system can show an authorization request dialog
  //   if (Platform.isIOS) {
  //     if (status == TrackingStatus.notDetermined) {
  //       // Show a custom explainer dialog before the system dialog
  //       if (await showCustomTrackingDialog(context)) {
  //         // Wait for dialog popping animation
  //         await Future.delayed(const Duration(milliseconds: 200));
  //         // Request system's tracking authorization dialog
  //         AppTrackingTransparency.requestTrackingAuthorization();
  //       }
  //     }
  //     AppTrackingTransparency.getAdvertisingIdentifier();
  //   }
  //   // final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  //   // print("UUID: $uuid");
  // }

  // Future<bool> showCustomTrackingDialog(BuildContext context) async =>
  //     await showDialog<bool>(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Hi User'),
  //         content: const Text(
  //           'We care about your privacy and data security. We keep this app free by showing ads. '
  //           'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
  //           'Our partners will collect data and use a unique identifier on your device to show you ads.',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: const Text("I'll decide later"),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, true),
  //             child: const Text('Allow tracking'),
  //           ),
  //         ],
  //       ),
  //     ) ??
  //     false;

  int _currentIndex = 2;
  final pages = [
    const Targetspage(),
    const OrderPage(),
    const TSEPage(),
    const BalancePage(),
    const SettingsPage(),
  ];

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.red[400]),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
        iconSize: 35,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Targets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_to_action_rounded),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            label: 'TSE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'Server',
          ),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        onTap: _onItemClick,
        unselectedIconTheme: const IconThemeData(color: Colors.black),
      ),
    );
  }
}
