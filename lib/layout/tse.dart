import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/ad_id.dart';
import 'package:trade_agent_v2/basic/url.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';

class TSEPage extends StatefulWidget {
  const TSEPage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<TSEPage> createState() => _TSEPageState();
}

class _TSEPageState extends State<TSEPage> {
  final BannerAd myBanner = BannerAd(
    adUnitId: bannerAdUnitID,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (ad, _) {
        // Dispose the ad here to free resources.
        ad.dispose();
      },
    ),
  );

  late Future<TSE> futureTSE;
  bool alreadyRemovedAd = false;

  @override
  void initState() {
    super.initState();
    myBanner.load();
    futureTSE = fetchTSE();
    widget.db.basicDao.getBasicByKey('remove_ad_status').then((value) => {
          if (value != null) {alreadyRemovedAd = value.value == 'true'}
        });
  }

  @override
  Widget build(BuildContext context) {
    final adWidget = AdWidget(ad: myBanner);
    final adContainer = Container(
      alignment: Alignment.center,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
      child: adWidget,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: trAppbar(
        context,
        S.of(context).tse,
        widget.db,
      ),
      body: FutureBuilder<TSE>(
        future: futureTSE,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            if (data.tickTime.toString().length < 10) {
              return Center(
                child: Text(
                  S.of(context).no_data,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            String type;
            Color tmp;
            if (data.chgType.toString() == 'Down') {
              tmp = Colors.green;
              type = '↘️';
            } else {
              tmp = Colors.red;
              type = '↗️';
            }
            return Column(
              children: [
                _buildAd(adContainer),
                Column(
                  // shrinkWrap: true,
                  children: [
                    generateRow(S.of(context).date, data.tickTime.toString().substring(0, 10), Colors.black),
                    generateRow(S.of(context).open, commaNumber(data.open.toString()), Colors.black),
                    generateRow(S.of(context).close, commaNumber(data.close.toString()), tmp),
                    const Divider(
                      color: Colors.black,
                    ),
                    generateRow(S.of(context).high, commaNumber(data.high.toString()), Colors.black),
                    generateRow(S.of(context).low, commaNumber(data.low.toString()), Colors.black),
                    const Divider(
                      color: Colors.black,
                    ),
                    generateRow(S.of(context).change_type, type, tmp),
                    generateRow(S.of(context).percent_change, '${data.pctChg}%', tmp),
                    generateRow(S.of(context).price_change, commaNumber(data.priceChg.toString()), tmp),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureTSE = fetchTSE();
                        });
                      },
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }

  Padding _buildAd(Container adContainer) {
    if (alreadyRemovedAd) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: adContainer,
    );
  }
}

String commaNumber(String n) {
  return n.replaceAllMapped(reg, mathFunc);
}

RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String mathFunc(Match match) {
  return '${match[1]},';
}

Widget generateRow(String columnName, String value, Color textColor) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$columnName: ',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(fontSize: 20, color: textColor),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<TSE> fetchTSE() async {
  try {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/tse/real-time'));
    if (response.statusCode == 200) {
      return TSE.fromJson(jsonDecode(response.body));
    } else {
      return TSE();
    }
  } catch (e) {
    return TSE();
  }
}

class TSE {
  TSE(
      {this.stock,
      this.tickTime,
      this.open,
      this.high,
      this.low,
      this.close,
      this.tickType,
      this.priceChg,
      this.pctChg,
      this.chgType,
      this.volume,
      this.volumeSum,
      this.amount,
      this.amountSum,
      this.yesterdayVolume,
      this.volumeRatio});

  TSE.fromJson(Map<String, dynamic> json) {
    stock = json['stock'] != null ? Stock.fromJson(json['stock']) : null;
    tickTime = json['tick_time'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    tickType = json['tick_type'];
    priceChg = json['price_chg'];
    pctChg = json['pct_chg'];
    chgType = json['chg_type'];
    volume = json['volume'];
    volumeSum = json['volume_sum'];
    amount = json['amount'];
    amountSum = json['amount_sum'];
    yesterdayVolume = json['yesterday_volume'];
    volumeRatio = json['volume_ratio'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (stock != null) {
      data['stock'] = stock!.toJson();
    }
    data['tick_time'] = tickTime;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['close'] = close;
    data['tick_type'] = tickType;
    data['price_chg'] = priceChg;
    data['pct_chg'] = pctChg;
    data['chg_type'] = chgType;
    data['volume'] = volume;
    data['volume_sum'] = volumeSum;
    data['amount'] = amount;
    data['amount_sum'] = amountSum;
    data['yesterday_volume'] = yesterdayVolume;
    data['volume_ratio'] = volumeRatio;
    return data;
  }

  Stock? stock;
  String? tickTime;
  num? open;
  num? high;
  num? low;
  num? close;
  String? tickType;
  num? priceChg;
  num? pctChg;
  String? chgType;
  num? volume;
  num? volumeSum;
  num? amount;
  num? amountSum;
  num? yesterdayVolume;
  num? volumeRatio;
}

class Stock {
  Stock({this.number, this.name, this.exchange, this.category});

  Stock.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    exchange = json['exchange'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['exchange'] = exchange;
    data['category'] = category;
    return data;
  }

  String? number;
  String? name;
  String? exchange;
  String? category;
}
