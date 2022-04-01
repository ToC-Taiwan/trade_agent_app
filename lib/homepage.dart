// import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:trade_agent_app/balance.dart';
import 'package:trade_agent_app/order.dart';
import 'package:trade_agent_app/settings.dart';
import 'package:trade_agent_app/strategy.dart';
import 'package:trade_agent_app/targets.dart';
import 'package:trade_agent_app/tse.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
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
