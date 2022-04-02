import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_app/url.dart';

class TSEPage extends StatefulWidget {
  const TSEPage({Key? key}) : super(key: key);

  @override
  State<TSEPage> createState() => _TSEPageState();
}

final String adUnitID = Platform.isAndroid ? 'ca-app-pub-1617900048851450/4933705826' : 'ca-app-pub-1617900048851450/8822922940';

class _TSEPageState extends State<TSEPage> {
  final BannerAd myBanner = BannerAd(
    adUnitId: adUnitID,
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

  @override
  void initState() {
    super.initState();
    myBanner.load();
    futureTSE = fetchTSE();
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
    return Center(
      child: FutureBuilder<TSE>(
        future: futureTSE,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            var widgetArr = <Widget>[];
            if (data.tickTime.toString().length > 10) {
              widgetArr.add(generateRow('Date', data.tickTime.toString().substring(0, 10)));
            } else {
              return const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              );
            }
            widgetArr.add(generateRow('Close', commaNumber(data.close.toString())));
            widgetArr.add(generateRow('Open', commaNumber(data.open.toString())));
            widgetArr.add(generateRow('High', commaNumber(data.high.toString())));
            widgetArr.add(generateRow('Low', commaNumber(data.low.toString())));
            widgetArr.add(generateRow('Volume', commaNumber(data.volume.toString())));
            widgetArr.add(generateRow('Yesterday Volume', commaNumber(data.yesterdayVolume.toString())));
            widgetArr.add(generateRow('Change Type', data.chgType.toString()));
            widgetArr.add(generateRow('Percent Change', data.pctChg.toString()));
            widgetArr.add(generateRow('Price Change', commaNumber(data.priceChg.toString())));
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                adContainer,
                ListView(
                  shrinkWrap: true,
                  children: widgetArr,
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
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

Widget generateRow(String columnName, String value) {
  return SizedBox(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
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
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<TSE> fetchTSE() async {
  final response = await http.get(Uri.parse('$tradeAgentURLPrefix/tse/real-time'));
  if (response.statusCode == 200) {
    return TSE.fromJson(jsonDecode(response.body));
  } else {
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
