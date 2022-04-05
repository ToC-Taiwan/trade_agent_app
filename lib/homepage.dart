import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:trade_agent_v2/layout/balance.dart';
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
    const StrategyPage(),
    const TSEPage(),
    const BalancePage(),
    // const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var title = 'Trade Agent V2';
    switch (_page) {
      case 0:
        title = 'Targets';
        break;
      case 1:
        title = 'Strategy';
        break;
      case 2:
        title = 'TSE';
        break;
      case 3:
        title = 'Balance';
        break;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_mark_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notification_important),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
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
          // Icon(Icons.computer, size: 30),
        ],
        color: Color.fromARGB(255, 217, 217, 217),
        buttonBackgroundColor: Colors.red[100],
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
