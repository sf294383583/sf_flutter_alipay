import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sf_flutter_alipay/sf_flutter_alipay.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await SfFlutterAlipay.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: () {
                  aliPay();
                },
                child: Text('支付'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void aliPay()async{
    AliPayResult payResult = await SfFlutterAlipay.aliPay(
        "alipay_sdk=alipay-sdk-java-3.3.49.ALL&app_id=2018112162215837&biz_content=%7B%22out_trade_no%22%3A%22JSZL12019112210012782926%22%2C%22total_amount%22%3A0.01%2C%22subject%22%3A%22%E8%B4%AD%E4%B9%B0%E4%BE%9B%E5%BA%94%E5%95%86%E4%BC%9A%E5%91%98VIP%22%2C%22goods_type%22%3A%220%22%2C%22product_code%22%3A%22FAST_INSTANT_TRADE_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2F47.100.119.84%3A43539%2Fcrec-api%2Fpay%2Falipay%2Fv1%2Fasync_notify&sign=BmI3m0Kew0K4MlW3zo4pgKk48FrF287isFdyhciEC4uOsTZON08RgVQ03DHCboojRX%2BYOIeh3KFSWHBV5jD332deCc4stPcjf%2BsO7Ne7nRy1s5cEybb2kXSlG0SlKqVwveEyI45V82yQXXwSWfyWe8f5OH9GKovgV4CH8Nar3frY8oVQncA%2Fl652tyXaiIFj16zUG6OxbOMsLkRPsRqWAxnTnvS%2BRaiCrzcC1r%2BxQDYOo%2BEHFXYhjgSSdQ6laJUFn5fZwYbYoG6%2F1za%2BmF1wt4KOKgtGmF%2BfYmCMsXMG1g4QiHDZvsLTSKKf9odBIviXFn3werg%2BepcswQGOdetSGA%3D%3D&sign_type=RSA2&timestamp=2019-11-22+10%3A01%3A27&version=1.0");
    print("payResult === $payResult");
  }
}
