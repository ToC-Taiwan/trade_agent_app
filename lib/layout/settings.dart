import 'package:flutter/material.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/layout/trade_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(S.of(context).settings),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(S.of(context).settings_of_notification),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(S.of(context).trade_configuration),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TradeConfigPage()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(S.of(context).language),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle),
              title: Text(S.of(context).remove_ads),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              leading: const Icon(Icons.info_rounded),
              title: Text(S.of(context).version),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0,
            ),
            ListTile(
              leading: const Icon(Icons.checklist_rounded),
              title: Text(S.of(context).terms_and_conditions_of_use),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0,
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_outlined),
              title: Text(S.of(context).about_me),
              trailing: const Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
    );
  }
}
