import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:trade_agent_v2/layout/balance.dart';
import 'package:trade_agent_v2/layout/order.dart';
import 'package:trade_agent_v2/layout/settings.dart';
import 'package:trade_agent_v2/layout/strategy.dart';
import 'package:trade_agent_v2/layout/targets.dart';
import 'package:trade_agent_v2/layout/tse.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final pages = [
    const Targetspage(),
    const OrderPage(),
    const TSEPage(),
    const BalancePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.health_and_safety_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StrategyPage()),
            ),
          ),
        ],
      ),
      body: pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        // index: 0,
        height: 70,
        items: const <Widget>[
          Icon(Icons.assignment_outlined, size: 30),
          Icon(Icons.call_to_action_rounded, size: 30),
          Icon(Icons.today_outlined, size: 30),
          Icon(Icons.money, size: 30),
          Icon(Icons.computer, size: 30),
        ],
        color: const Color.fromARGB(255, 255, 212, 212),
        buttonBackgroundColor: Colors.red[100],
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
