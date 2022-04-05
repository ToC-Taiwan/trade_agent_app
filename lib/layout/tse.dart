import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trade_agent_v2/basic/ad_id.dart';
import 'package:trade_agent_v2/basic/url.dart';

class TSEPage extends StatefulWidget {
  const TSEPage({Key? key}) : super(key: key);

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
    return FutureBuilder<TSE>(
      future: futureTSE,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;
          var widgetArr = <Widget>[];
          if (data.tickTime.toString().length > 10) {
            widgetArr.add(generateRow('Date', data.tickTime.toString().substring(0, 10), Colors.black));
          } else {
            return const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
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
          widgetArr.add(generateRow('Close', commaNumber(data.close.toString()), Colors.black));
          widgetArr.add(SizedBox(
            height: 40,
          ));
          // widgetArr.add(generateRow('Volume', commaNumber(data.volume.toString()), Colors.black));
          widgetArr.add(generateRow('Open', commaNumber(data.open.toString()), Colors.black));
          widgetArr.add(generateRow('High', commaNumber(data.high.toString()), Colors.black));
          widgetArr.add(generateRow('Low', commaNumber(data.low.toString()), Colors.black));
          widgetArr.add(SizedBox(
            height: 40,
          ));
          // widgetArr.add(generateRow('Yesterday Volume', commaNumber(data.yesterdayVolume.toString())));
          widgetArr.add(generateRow('Change Type', type, tmp));
          widgetArr.add(generateRow('Percent Change', data.pctChg.toString(), tmp));
          widgetArr.add(generateRow('Price Change', commaNumber(data.priceChg.toString()), tmp));
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
  var client = HttpClient();
  client.badCertificateCallback = (cert, host, port) => true;
  var request = await client.getUrl(Uri.parse('$tradeAgentURLPrefix/tse/real-time'));
  var result = await request.close();
  if (result.statusCode == 200) {
    var data = await result.transform(utf8.decoder).join();
    return TSE.fromJson(jsonDecode(data));
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
