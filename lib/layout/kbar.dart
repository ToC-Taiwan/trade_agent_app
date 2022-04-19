import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Kbar extends StatefulWidget {
  const Kbar({Key? key, required this.stockNum, required this.stockName}) : super(key: key);

  final String stockNum;
  final String stockName;

  @override
  State<Kbar> createState() => _KbarState();
}

class _KbarState extends State<Kbar> {
  List<Candle> candles = [];
  bool themeIsDark = false;

  @override
  void initState() {
    fetchCandles().then((value) {
      setState(() {
        candles = value;
      });
    });
    super.initState();
  }

  Future<List<Candle>> fetchCandles() async {
    final uri = Uri.parse('https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1h');
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>).map((e) => Candle.fromJson(e)).toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
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
          ),
        ),
      ),
    );
  }
}
