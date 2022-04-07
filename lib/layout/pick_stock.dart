import 'package:flutter/material.dart';
import 'package:trade_agent_v2/database.dart';

class PickStockPage extends StatefulWidget {
  const PickStockPage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<PickStockPage> createState() => _PickStockPageState();
}

class _PickStockPageState extends State<PickStockPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   futureTargets = fetchTargets(current, -1);
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Center(child: Text('data')),
        ],
      ),
    );
  }
}
