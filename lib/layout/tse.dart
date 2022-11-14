import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/basic.dart';
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
  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width - (4 * _insets);

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
    AdSize size = AdSize.getInlineAdaptiveBannerAdSize(_adWidth.truncate(), 60);
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

  late Future<TSE> futureTSE;
  bool alreadyRemovedAd = false;

  @override
  void initState() {
    super.initState();
    // myBanner.load();
    futureTSE = fetchTSE();
    widget.db.basicDao.getBasicByKey('remove_ad_status').then((value) => {
          if (value != null) {alreadyRemovedAd = value.value == 'true'}
        });
  }

  @override
  Widget build(BuildContext context) {
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
            if (data.snapTime.toString().length < 10) {
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
                _buildAd(),
                Column(
                  // shrinkWrap: true,
                  children: [
                    generateRow(S.of(context).date, data.snapTime.toString().substring(0, 10), Colors.black),
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

  Widget _buildAd() {
    if (alreadyRemovedAd) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _getAdWidget(),
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
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/stream/tse/snapshot'));
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
      // {this.stock,
      {this.snapTime,
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
    snapTime = json['snap_time'];
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
    data['snap_time'] = snapTime;
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

  String? snapTime;
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
