import 'package:flutter/material.dart';
import 'package:trade_agent_v2/layout/settings.dart';

AppBar trAppbar(BuildContext context, String title, {List<Widget>? actions}) {
  var normalAction = <Widget>[
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
  ];
  return AppBar(
    centerTitle: false,
    elevation: 1,
    title: Text(title),
    actions: actions ?? normalAction,
  );
}
