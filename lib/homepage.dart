import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/layout/balance.dart';
import 'package:trade_agent_v2/layout/pick_stock.dart';
import 'package:trade_agent_v2/layout/strategy.dart';
import 'package:trade_agent_v2/layout/targets.dart';
import 'package:trade_agent_v2/layout/tse.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.db}) : super(key: key);
  final AppDatabase db;

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 2;
  List pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      const Targetspage(),
      const StrategyPage(),
      PickStockPage(
        db: widget.db,
      ),
      const TSEPage(),
      const BalancePage(),
      // const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
        height: 70,
        items: const <Widget>[
          Icon(Icons.assignment_outlined, size: 30),
          Icon(Icons.call_to_action_rounded, size: 30),
          Icon(Icons.dashboard_customize, size: 30),
          Icon(Icons.today_outlined, size: 30),
          Icon(Icons.money, size: 30),
        ],
        color: const Color.fromARGB(255, 217, 217, 217),
        buttonBackgroundColor: const Color.fromARGB(255, 255, 221, 68),
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 150),
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
