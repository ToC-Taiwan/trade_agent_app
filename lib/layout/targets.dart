import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/basic.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/layout/kbar.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';

class Targetspage extends StatefulWidget {
  const Targetspage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  _TargetspageState createState() => _TargetspageState();
}

class _TargetspageState extends State<Targetspage> {
  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width * 2 / 3 - (2 * _insets);
  double get _adHight => MediaQuery.of(context).size.height / 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  void _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    setState(() {
      _inlineAdaptiveAd = null;
      _isLoaded = false;
    });

    // Get an inline adaptive size for the current orientation.
    AdSize size = AdSize.getInlineAdaptiveBannerAdSize(_adWidth.truncate(), _adHight.truncate());
    _inlineAdaptiveAd = BannerAd(
      adUnitId: bannerAdUnitID,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) async {
          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          var bannerAd = ad as BannerAd;
          final size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            return;
          }

          setState(() {
            _inlineAdaptiveAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd!.load();
  }

  /// Gets a widget containing the ad, if one is loaded.
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation && _inlineAdaptiveAd != null && _isLoaded && _adSize != null) {
          return Align(
            child: SizedBox(
              width: _adWidth,
              height: _adSize!.height.toDouble(),
              child: AdWidget(
                ad: _inlineAdaptiveAd!,
              ),
            ),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inlineAdaptiveAd?.dispose();
  }

  TextEditingController textFieldController = TextEditingController();
  late Future<List<Target>> futureTargets;
  List<Target> current = [];
  bool alreadyRemovedAd = false;

  @override
  void initState() {
    super.initState();
    futureTargets = fetchTargets(current, -1);
    widget.db.basicDao.getBasicByKey('remove_ad_status').then((value) => {
          if (value != null) {alreadyRemovedAd = value.value == 'true'}
        });
  }

  void _onItemClick(num opt) {
    setState(() {
      futureTargets = fetchTargets(current, opt);
    });
  }

  void clearTextField() {
    textFieldController.clear();
    _onItemClick(-1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).targets,
        widget.db,
      ),
      body: SizedBox(
        child: FutureBuilder<List<Target>>(
          future: futureTargets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    S.of(context).no_data,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                );
              }
              var tmp = <Widget>[];
              current = snapshot.data!;
              for (final i in snapshot.data!) {
                if (i.rank == -1) {
                  continue;
                }
                if (i.rank! == 6 && !alreadyRemovedAd) {
                  tmp.add(
                    buildTile(
                      2,
                      2,
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: _getAdWidget(),
                      ),
                    ),
                  );
                }
                tmp.add(
                  buildTile(
                    1,
                    1,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: AutoSizeText(
                              i.stock!.number!,
                              style: const TextStyle(fontSize: 22, color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoSizeText(
                            i.stock!.name!,
                            style: const TextStyle(fontSize: 22, color: Color.fromARGB(255, 138, 155, 208), fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  commaNumber('${i.volume! ~/ 1000}k'),
                                  style: const TextStyle(fontSize: 14, color: Colors.red),
                                ),
                                AutoSizeText(
                                  i.stock!.lastClose!.toString(),
                                  style: const TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Text(i.rank.toString()),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Kbar(
                            stockNum: i.stock!.number!,
                            stockName: i.stock!.name!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: textFieldController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: S.of(context).search,
                        hintText: S.of(context).stock_number,
                        suffixIcon: IconButton(
                          onPressed: clearTextField,
                          icon: const Icon(Icons.clear, color: Colors.grey),
                        ),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          _onItemClick(int.parse(val));
                        } else {
                          _onItemClick(-1);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: StaggeredGrid.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: tmp,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          },
        ),
      ),
    );
  }
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

String commaNumber(String n) {
  return n.replaceAllMapped(reg, mathFunc);
}

String mathFunc(Match match) {
  return '${match[1]},';
}

Widget buildTile(int cross, int main, Widget child, {Function()? onTap}) {
  return StaggeredGridTile.count(
    crossAxisCellCount: cross,
    mainAxisCellCount: main,
    child: Material(
      color: Colors.grey[100],
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.blueGrey.shade50,
      child: InkWell(
        onTap: onTap != null ? () => onTap() : () {},
        child: child,
      ),
    ),
  );
}

Future<List<Target>> fetchTargets(List<Target> current, num opt) async {
  var targetArr = <Target>[];
  if (opt == -1) {
    try {
      final response = await http.get(Uri.parse('$tradeAgentURLPrefix/targets'));
      if (response.statusCode == 200) {
        for (final Map<String, dynamic> i in jsonDecode(response.body)) {
          targetArr.add(Target.fromJson(i));
        }
        return targetArr;
      } else {
        return targetArr;
      }
    } catch (_) {
      return targetArr;
    }
  } else {
    for (final i in current) {
      if (i.stock!.number!.substring(0, opt.toString().length) == opt.toString()) {
        targetArr.add(i);
      }
    }
  }
  return targetArr;
}

class Target {
  Target({this.stock, this.tradeDay, this.rank, this.volume});

  Target.fromJson(Map<String, dynamic> json) {
    stock = json['stock'] != null ? Stock.fromJson(json['stock']) : null;
    tradeDay = json['trade_day'];
    rank = json['rank'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (stock != null) {
      data['stock'] = stock!.toJson();
    }
    data['trade_day'] = tradeDay;
    data['rank'] = rank;
    data['volume'] = volume;
    return data;
  }

  Stock? stock;
  String? tradeDay;
  num? rank;
  num? volume;
}

class Stock {
  Stock({this.number, this.name, this.exchange, this.category, this.dayTrade, this.lastClose});

  Stock.fromJson(Map<dynamic, dynamic> json) {
    number = json['number'];
    name = json['name'];
    exchange = json['exchange'];
    category = json['category'];
    dayTrade = json['day_trade'];
    lastClose = json['last_close'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['exchange'] = exchange;
    data['category'] = category;
    data['day_trade'] = dayTrade;
    data['last_close'] = lastClose;
    return data;
  }

  String? number;
  String? name;
  String? exchange;
  String? category;
  bool? dayTrade;
  num? lastClose;
}
