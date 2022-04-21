import 'package:flutter/material.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/layout/terms.dart';
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
  late Future<Basic?> languageGroup;

  String originalLanguage = '';
  bool languageChanged = false;

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
    languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
    futureVersion = widget.db.basicDao.getBasicByKey('version');
  }

  Widget _showShouldRestart(BuildContext context) {
    if (!languageChanged) {
      return Container();
    }
    return ListTile(
      trailing: Text(S.of(context).restart_to_apply_changes, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    );
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
              leading: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: Text(S.of(context).trade_configuration),
              // trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TradeConfigPage()),
              ),
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.only(left: 50),
              maintainState: true,
              leading: const Icon(
                Icons.language,
                color: Colors.black,
              ),
              title: Text(
                S.of(context).language,
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
              children: [
                FutureBuilder<Basic?>(
                  future: languageGroup,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (originalLanguage.isEmpty) {
                        originalLanguage = snapshot.data!.value;
                      }
                      return RadioListTile<String>(
                        activeColor: Colors.green,
                        value: 'en',
                        title: const Text(
                          'English',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        groupValue: snapshot.data!.value,
                        onChanged: (value) {
                          setState(() {
                            snapshot.data!.value = value!;
                            if (value != originalLanguage) {
                              languageChanged = true;
                            } else {
                              languageChanged = false;
                            }
                            widget.db.basicDao.updateBasic(snapshot.data!);
                            languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
                          });
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                FutureBuilder<Basic?>(
                  future: languageGroup,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RadioListTile<String>(
                        activeColor: Colors.green,
                        value: 'zh_Hant',
                        title: const Text(
                          '繁體中文',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        groupValue: snapshot.data!.value,
                        onChanged: (value) {
                          setState(() {
                            snapshot.data!.value = value!;
                            if (value != originalLanguage) {
                              languageChanged = true;
                            } else {
                              languageChanged = false;
                            }
                            widget.db.basicDao.updateBasic(snapshot.data!);
                            languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
                          });
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                FutureBuilder<Basic?>(
                  future: languageGroup,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RadioListTile<String>(
                        activeColor: Colors.green,
                        value: 'zh_Hans',
                        title: const Text(
                          '简体中文',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        groupValue: snapshot.data!.value,
                        onChanged: (value) {
                          setState(() {
                            snapshot.data!.value = value!;
                            if (value != originalLanguage) {
                              languageChanged = true;
                            } else {
                              languageChanged = false;
                            }
                            widget.db.basicDao.updateBasic(snapshot.data!);
                            languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
                          });
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                _showShouldRestart(context),
              ],
            ),
            ExpansionTile(
              childrenPadding: const EdgeInsets.only(left: 50),
              maintainState: true,
              leading: const Icon(
                Icons.remove_circle,
                color: Colors.black,
              ),
              title: Text(
                S.of(context).remove_ads,
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.keyboard_arrow_right),
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        primary: Colors.black,
                      ),
                      onPressed: () => {},
                      child: const Text(r'$0.99'),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        primary: Colors.black,
                      ),
                      onPressed: () => {},
                      child: const Text('還原購買'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.info_rounded,
                color: Colors.black,
              ),
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
            const Divider(
              color: Colors.grey,
              thickness: 0,
            ),
            ListTile(
              leading: const Icon(
                Icons.checklist_rounded,
                color: Colors.black,
              ),
              title: Text(S.of(context).terms_and_conditions_of_use),
              // trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfUsePage()),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0,
            ),
            ListTile(
              leading: const Icon(
                Icons.settings_accessibility_outlined,
                color: Colors.black,
              ),
              title: Text(S.of(context).my_web_site),
              // trailing: const Icon(Icons.keyboard_arrow_right),
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
