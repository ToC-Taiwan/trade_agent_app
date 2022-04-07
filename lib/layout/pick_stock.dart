import 'package:flutter/material.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/models/pick_stock.dart';
import 'package:trade_agent_v2/utils/app_bar.dart';

class PickStockPage extends StatefulWidget {
  const PickStockPage({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

  @override
  State<PickStockPage> createState() => _PickStockPageState();
}

class _PickStockPageState extends State<PickStockPage> {
  late Future<List<PickStock>> stockArray;

  @override
  void initState() {
    super.initState();
    stockArray = widget.db.pickStockDao.getAllPickStock();
  }

  @override
  Widget build(BuildContext context) {
    var actions = [
      IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(S.of(context).delete_all_pick_stock),
              content: Text(S.of(context).delete_all_pick_stock_confirm),
              actions: [
                OutlinedButton(
                  child: Text(
                    S.of(context).cancel,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                OutlinedButton(
                  child: Text(
                    S.of(context).delete,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    widget.db.pickStockDao.deleteAllPickStock();
                    setState(() {
                      stockArray = widget.db.pickStockDao.getAllPickStock();
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            var textFieldController = TextEditingController();
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Type the stock number'),
                  content: TextField(
                    onChanged: (value) {},
                    controller: textFieldController,
                    decoration: const InputDecoration(hintText: 'Stock Number'),
                  ),
                  actions: <Widget>[
                    OutlinedButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    OutlinedButton(
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        var t = PickStock(
                          textFieldController.text,
                          textFieldController.text,
                          1,
                          textFieldController.text,
                          textFieldController.text,
                          textFieldController.text,
                        );
                        widget.db.pickStockDao.insertPickStock(t);
                        setState(() {
                          stockArray = widget.db.pickStockDao.getAllPickStock();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      )
    ];
    return Scaffold(
      appBar: trAppbar(
        context,
        S.of(context).pick_stock,
        actions: actions,
      ),
      body: FutureBuilder<List<PickStock>>(
        future: stockArray,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).no_pick_stock,
                      style: const TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        S.of(context).click_plus_to_add_stock,
                        style: const TextStyle(fontSize: 22, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(snapshot.data![index].stockNum)),
                      Expanded(
                          child: Text(
                        snapshot.data![index].stockNum,
                        textAlign: TextAlign.end,
                      )),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(child: Text(snapshot.data![index].stockNum)),
                      Expanded(
                          child: Text(
                        snapshot.data![index].isTarget.toString(),
                        textAlign: TextAlign.end,
                      )),
                    ],
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete'),
                          content: const Text('Are you sure you want to delete this stock?'),
                          actions: <Widget>[
                            OutlinedButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            OutlinedButton(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.db.pickStockDao.deletePickStock(snapshot.data![index]);
                                  stockArray = widget.db.pickStockDao.getAllPickStock();
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
