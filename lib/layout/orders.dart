import 'dart:convert';

import 'package:date_format/date_format.dart' as df;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/basic/base.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.date});

  final String date;

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  Future<FutureOrder?> futureOrder = Future.value();

  @override
  void initState() {
    super.initState();
    futureOrder = fetchOrders(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(widget.date),
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
          child: FutureBuilder<FutureOrder?>(
            future: futureOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var orderList = snapshot.data!.orders!.reversed.toList();
                var count = snapshot.data!.orders!.length;
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    color: Colors.grey,
                  ),
                  itemCount: count,
                  itemBuilder: (context, index) {
                    var order = orderList[index].baseOrder!;
                    var code = orderList[index].code;
                    return ListTile(
                      leading: Icon(Icons.book_outlined, color: (order.action == 1 || order.action == 4) ? Colors.red : Colors.green),
                      title: Text(code!),
                      subtitle: Text(df.formatDate(DateTime.parse(order.orderTime!).add(const Duration(hours: 8)),
                          [df.yyyy, '-', df.mm, '-', df.dd, ' ', df.HH, ':', df.nn, ':', df.ss])),
                      trailing: Text(
                        '${order.price.toString()} x ${order.quantity.toString()}',
                        style: GoogleFonts.getFont(
                          'Source Code Pro',
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: (order.action == 1 || order.action == 4) ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              }
              return const Text('-');
            },
          ),
        ),
      ),
    );
  }
}

class FutureOrder {
  FutureOrder({this.orders});

  FutureOrder.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }
  List<Orders>? orders;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  Orders({this.baseOrder, this.code, this.manual});

  Orders.fromJson(Map<String, dynamic> json) {
    baseOrder = json['base_order'] != null ? BaseOrder.fromJson(json['base_order']) : null;
    code = json['code'];
    manual = json['manual'];
  }
  BaseOrder? baseOrder;
  String? code;
  bool? manual;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (baseOrder != null) {
      data['base_order'] = baseOrder!.toJson();
    }
    data['code'] = code;
    data['manual'] = manual;
    return data;
  }
}

class BaseOrder {
  BaseOrder({
    this.orderId,
    this.status,
    this.orderTime,
    this.action,
    this.price,
    this.quantity,
    this.tradeTime,
    this.tickTime,
    this.groupId,
  });

  BaseOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    status = json['status'];
    orderTime = json['order_time'];
    action = json['action'];
    price = json['price'];
    quantity = json['quantity'];
    tradeTime = json['trade_time'];
    tickTime = json['tick_time'];
    groupId = json['group_id'];
  }
  String? orderId;
  int? status;
  String? orderTime;
  int? action;
  int? price;
  int? quantity;
  String? tradeTime;
  String? tickTime;
  String? groupId;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['status'] = status;
    data['order_time'] = orderTime;
    data['action'] = action;
    data['price'] = price;
    data['quantity'] = quantity;
    data['trade_time'] = tradeTime;
    data['tick_time'] = tickTime;
    data['group_id'] = groupId;
    return data;
  }
}

Future<FutureOrder> fetchOrders(String date) async {
  try {
    final response = await http.get(Uri.parse('$tradeAgentURLPrefix/order/date/$date'));
    if (response.statusCode == 200) {
      return FutureOrder.fromJson(jsonDecode(response.body));
    } else {
      return FutureOrder();
    }
  } catch (e) {
    return FutureOrder();
  }
}
