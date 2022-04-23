import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/url.dart';
import 'package:trade_agent_v2/generated/l10n.dart';

class Kbar extends StatefulWidget {
  const Kbar({Key? key, required this.stockNum, required this.stockName}) : super(key: key);

  final String stockNum;
  final String stockName;

  @override
  State<Kbar> createState() => _KbarState();
}

class _KbarState extends State<Kbar> {
  List<Candle> candles = [];
  String startTime = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();
    fetchCandles(widget.stockNum, startTime, '30').then((value) {
      if (mounted) {
        setState(() {
          candles = value;
        });
      }
    });
  }

  Future<List<Candle>> fetchCandles(String stockNum, String startDate, String interval) async {
    var candleArr = <Candle>[];
    try {
      final response = await http.get(Uri.parse('$tradeAgentURLPrefix/history/day_kbar/$stockNum/$startDate/$interval'));
      if (response.statusCode == 200) {
        for (final Map<String, dynamic> i in jsonDecode(response.body)) {
          var tmp = KbarData.fromJson(i);
          var time = DateTime.parse(tmp.tickTime!);
          candleArr.add(Candle(
              date: time.add(const Duration(hours: 8)),
              high: tmp.high!.toDouble(),
              low: tmp.low!.toDouble(),
              open: tmp.open!.toDouble(),
              close: tmp.close!.toDouble(),
              volume: tmp.volume!.toDouble()));
        }
        startTime = candleArr[candleArr.length - 1].date.add(const Duration(days: -1)).toString().substring(0, 10);
        return candleArr;
      } else {
        return candleArr;
      }
    } catch (e) {
      return candleArr;
    }
  }

  Future<void> addCandles(String stockNum, String startDate, String interval) async {
    var newData = await fetchCandles(widget.stockNum, startTime, '30');
    if (mounted) {
      setState(() {
        candles += newData;
        startTime = candles[candles.length - 1].date.add(const Duration(days: -1)).toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text('${widget.stockNum} ${widget.stockName}'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: Center(
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => Kbar(
                      stockNum: widget.stockNum,
                      stockName: widget.stockName,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Text(
                S.of(context).display,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('${widget.stockNum} ${widget.stockName}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Center(
        child: SafeArea(
          child: Candlesticks(
            candles: candles,
            onLoadMoreCandles: () async {
              var newData = await fetchCandles(widget.stockNum, startTime, '30');
              if (mounted) {
                setState(() {
                  candles += newData;
                });
              }
            },
            actions: [
              ToolBarAction(
                child: const Icon(Icons.refresh),
                onPressed: () async {
                  var newData = await fetchCandles(widget.stockNum, startTime, '30');
                  if (mounted) {
                    setState(() {
                      candles += newData;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class KbarData {
  KbarData({this.tickTime, this.close, this.open, this.high, this.low, this.volume});

  KbarData.fromJson(Map<String, dynamic> json) {
    tickTime = json['tick_time'];
    close = json['close'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tick_time'] = tickTime;
    data['close'] = close;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    data['volume'] = volume;
    return data;
  }

  String? tickTime;
  num? close;
  num? open;
  num? high;
  num? low;
  int? volume;
}
