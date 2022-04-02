import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trade_agent_v2/url.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Order>> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Order>>(
        future: futureOrder,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            var widgetArr = <Widget>[];
            for (final i in data!) {
              widgetArr.add(generateRow(i));
            }
            if (widgetArr.isEmpty) {
              return const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              );
            }
            return ListView(children: widgetArr);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

Widget generateRow(Order order) {
  var action = '';
  if (order.action == 1) {
    action = 'Buy';
  } else {
    action = 'Sell';
  }
  return Container(
    color: Colors.amber[100],
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    child: Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Stock ID',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Action',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Price',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Quantity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Order ID',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Order Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order.stockId.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              Text(
                action,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                order.price.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              Text(
                order.quantity.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              Text(
                order.status.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              Text(
                order.orderId.toString(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              Text(
                order.orderTime.toString().substring(0, 19),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Future<List<Order>> fetchOrder() async {
  final response = await http.get(Uri.parse('$tradeAgentURLPrefix/order'));
  var result = <Order>[];
  if (response.statusCode == 200) {
    for (final Map<String, dynamic> i in jsonDecode(response.body)) {
      result.add(Order.fromJson(i));
    }
    return result;
  } else {
    return result;
  }
}

class Order {
  Order({this.stockId, this.orderTime, this.action, this.price, this.quantity, this.status, this.orderId});

  Order.fromJson(Map<String, dynamic> json) {
    stockId = json['stock_id'];
    orderTime = json['order_time'];
    action = json['action'];
    price = json['price'];
    quantity = json['quantity'];
    status = json['status'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['stock_id'] = stockId;
    data['order_time'] = orderTime;
    data['action'] = action;
    data['price'] = price;
    data['quantity'] = quantity;
    data['status'] = status;
    data['order_id'] = orderId;
    return data;
  }

  num? stockId;
  String? orderTime;
  num? action;
  num? price;
  num? quantity;
  num? status;
  String? orderId;
}
