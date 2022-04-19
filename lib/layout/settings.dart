import 'package:flutter/material.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/layout/trade_config.dart';
import 'package:trade_agent_v2/models/basic.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<Basic?> futureVersion;

  void _launchInWebViewOrVC(String url) async {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
    );
  }

  @override
  void initState() {
    super.initState();
    futureVersion = widget.db.basicDao.getBasicByKey('version');
  }

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
            // ListTile(
            //   leading: const Icon(Icons.notifications),
            //   title: Text(S.of(context).settings_of_notification),
            //   trailing: const Icon(Icons.keyboard_arrow_right),
            // ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(S.of(context).trade_configuration),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TradeConfigPage()),
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.language),
            //   title: Text(S.of(context).language),
            //   trailing: const Icon(Icons.keyboard_arrow_right),
            // ),
            // ListTile(
            //   leading: const Icon(Icons.remove_circle),
            //   title: Text(S.of(context).remove_ads),
            //   trailing: const Icon(Icons.keyboard_arrow_right),
            // ),
            ListTile(
              leading: const Icon(Icons.info_rounded),
              title: Text(S.of(context).version),
              trailing: FutureBuilder<Basic?>(
                future: futureVersion,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        snapshot.data!.value,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  return const Text('-');
                },
              ),
            ),
            //
            // const Divider(
            //   color: Colors.grey,
            //   thickness: 0,
            // ),
            // ListTile(
            //   leading: const Icon(Icons.checklist_rounded),
            //   title: Text(S.of(context).terms_and_conditions_of_use),
            //   trailing: const Icon(Icons.keyboard_arrow_right),
            //   onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const TermsOfUsePage()),
            //   ),
            // ),
            const Divider(
              color: Colors.grey,
              thickness: 0,
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_outlined),
              title: Text(S.of(context).about_me),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                _launchInWebViewOrVC('https://blog.tocandraw.com/');
              },
            )
          ],
        ),
      ),
    );
  }
}
