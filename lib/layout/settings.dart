import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:trade_agent_v2/database.dart';
import 'package:trade_agent_v2/entity/entity.dart';
import 'package:trade_agent_v2/generated/l10n.dart';
import 'package:trade_agent_v2/layout/trade_config.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({required this.db, Key? key}) : super(key: key);
  final AppDatabase db;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

const String _kUpgradeId = 'com.tocandraw.removeAd';
const List<String> _kProductIds = <String>[
  _kUpgradeId,
];

class _SettingsPageState extends State<SettingsPage> {
  late Future<Basic?> futureVersion;
  late Future<Basic?> languageGroup;

  String originalLanguage = '';
  bool languageChanged = false;
  bool alreadyRemovedAd = false;

  Future<void> _launchInWebViewOrVC(Uri url) async {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool _isAvailable = false;
  bool _loading = true;

  @override
  void initState() {
    _inAppPurchase.purchaseStream.listen(_listenToPurchaseUpdated);
    initStoreInfo();
    super.initState();
    languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
    futureVersion = widget.db.basicDao.getBasicByKey('version');
    widget.db.basicDao.getBasicByKey('remove_ad_status').then(
          (value) => {
            if (value != null) {alreadyRemovedAd = value.value == 'true'}
          },
        );
  }

  Future<void> initStoreInfo() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>().setDelegate(null);
    }
    super.dispose();
  }

  Widget _showShouldRestart(BuildContext context) {
    if (!languageChanged) {
      return Container();
    }
    return ListTile(
      trailing: Text(S.of(context).restart_to_apply_changes, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: Text(S.of(context).settings),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Column(
            children: [
              // ListTile(
              //   leading: const Icon(Icons.notifications),
              //   title: Text(S.of(context).settings_of_notification),
              //   trailing: const Icon(Icons.keyboard_arrow_right),
              // ),
              ExpansionTile(
                childrenPadding: const EdgeInsets.only(left: 50),
                maintainState: true,
                leading: const Icon(
                  Icons.language,
                  color: Colors.black,
                ),
                title: Text(
                  S.of(context).language,
                  style: const TextStyle(color: Colors.black),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
                children: [
                  FutureBuilder<Basic?>(
                    future: languageGroup,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (originalLanguage.isEmpty) {
                          originalLanguage = snapshot.data!.value;
                        }
                        return RadioListTile<String>(
                          activeColor: Colors.green,
                          value: 'en',
                          title: const Text(
                            'English',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          groupValue: snapshot.data!.value,
                          onChanged: (value) {
                            setState(() {
                              snapshot.data!.value = value!;
                              if (value != originalLanguage) {
                                languageChanged = true;
                              } else {
                                languageChanged = false;
                              }
                              widget.db.basicDao.updateBasic(snapshot.data!);
                              languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
                            });
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  FutureBuilder<Basic?>(
                    future: languageGroup,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return RadioListTile<String>(
                          activeColor: Colors.green,
                          value: 'zh_Hant',
                          title: const Text(
                            '繁體中文',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          groupValue: snapshot.data!.value,
                          onChanged: (value) {
                            setState(() {
                              snapshot.data!.value = value!;
                              if (value != originalLanguage) {
                                languageChanged = true;
                              } else {
                                languageChanged = false;
                              }
                              widget.db.basicDao.updateBasic(snapshot.data!);
                              languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
                            });
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  FutureBuilder<Basic?>(
                    future: languageGroup,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return RadioListTile<String>(
                          activeColor: Colors.green,
                          value: 'zh_Hans',
                          title: const Text(
                            '简体中文',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          groupValue: snapshot.data!.value,
                          onChanged: (value) {
                            setState(() {
                              snapshot.data!.value = value!;
                              if (value != originalLanguage) {
                                languageChanged = true;
                              } else {
                                languageChanged = false;
                              }
                              widget.db.basicDao.updateBasic(snapshot.data!);
                              languageGroup = widget.db.basicDao.getBasicByKey('language_setup');
                            });
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                  _showShouldRestart(context),
                ],
              ),
              _buildRemoveAdTile(),
              ListTile(
                leading: const Icon(
                  Icons.info_rounded,
                  color: Colors.black,
                ),
                title: Text(S.of(context).version),
                trailing: FutureBuilder<Basic?>(
                  future: futureVersion,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '${snapshot.data!.value} Latest Version',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    return const Text('-');
                  },
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0,
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: Text(S.of(context).trade_configuration),
                subtitle: Text(S.of(context).read_only),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TradeConfigPage()),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0,
              ),

              ListTile(
                leading: const Icon(
                  Icons.settings_accessibility_outlined,
                  color: Colors.black,
                ),
                title: Text(S.of(context).about_me),
                // trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  _launchInWebViewOrVC(Uri(scheme: 'https', path: 'blog.tocandraw.com'));
                },
              ),
            ],
          ),
        ),
      );

  Column _buildProductList() {
    if (_loading) {
      Column();
    }
    if (!_isAvailable) {
      return Column();
    }

    final productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(
        ListTile(
          title: Text(S.of(context).product_list_abnormal, style: const TextStyle(color: Colors.black)),
        ),
      );
    }

    final purchases = Map<String, PurchaseDetails>.fromEntries(
      _purchases.map(
        (purchase) {
          if (purchase.pendingCompletePurchase) {
            _inAppPurchase.completePurchase(purchase);
          }
          return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
        },
      ),
    );

    productList.addAll(
      _products.map(
        (productDetails) {
          final previousPurchase = purchases[productDetails.id];
          return ListTile(
            title: Text(
              productDetails.title,
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              productDetails.description,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: (previousPurchase != null || alreadyRemovedAd)
                ? const Icon(Icons.check)
                : TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[800],
                    ),
                    onPressed: () {
                      late PurchaseParam purchaseParam;
                      purchaseParam = PurchaseParam(
                        productDetails: productDetails,
                      );
                      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
                    },
                    child: Text(productDetails.price),
                  ),
          );
        },
      ),
    );
    return Column(children: productList);
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return ListTile(
      title: Text(S.of(context).already_purchased),
      // subtitle: Text(S.of(context).already_purchased),
      trailing: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green[800],
        ),
        onPressed: _inAppPurchase.restorePurchases,
        child: Text(S.of(context).restore),
      ),
    );
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kUpgradeId) {
      final dbRemoveAdStatus = await widget.db.basicDao.getBasicByKey('remove_ad_status');
      if (dbRemoveAdStatus != null) {
        dbRemoveAdStatus.value = 'true';
        await widget.db.basicDao.updateBasic(dbRemoveAdStatus);
      } else {
        await widget.db.basicDao.insertBasic(Basic('remove_ad_status', 'true'));
      }
    }
    setState(() {
      _purchases.add(purchaseDetails);
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails)
      // IMPORTANT!! Always verify a purchase before delivering the product.
      // For the purpose of an example, we directly return true.
      =>
      Future<bool>.value(true);

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
        final valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          await deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
          return;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  ExpansionTile _buildRemoveAdTile() {
    if (Platform.isAndroid) {
      return ExpansionTile(
        maintainState: true,
        leading: const Icon(
          Icons.workspace_premium,
          color: Colors.black,
        ),
        title: Text(
          S.of(context).developing,
          style: const TextStyle(color: Colors.black),
        ),
      );
    }
    return ExpansionTile(
      childrenPadding: const EdgeInsets.only(left: 50),
      maintainState: true,
      leading: const Icon(
        Icons.remove_circle,
        color: Colors.black,
      ),
      title: Text(
        S.of(context).remove_ads,
        style: const TextStyle(color: Colors.black),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      children: [
        _buildProductList(),
        _buildRestoreButton(),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) => true;

  @override
  bool shouldShowPriceConsent() => false;
}
