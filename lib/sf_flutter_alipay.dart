import 'dart:async';

import 'package:flutter/services.dart';

class SfFlutterAlipay {
  static const MethodChannel _channel = const MethodChannel('sf_flutter_alipay');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AliPayResult> aliPay(String orderInfo) async {
    dynamic result = await _channel.invokeMethod("aliPay", {"orderInfo": orderInfo});
    print('result === $result');
    return AliPayResult(result['resultStatus'], result['memo'], result['result']);
  }
}

class AliPayResult {
  //9000	订单支付成功
  //8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
  //4000	订单支付失败
  //5000	重复请求
  //6001	用户中途取消
  //6002	网络连接出错
  //6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
  //其它	其它支付错误
  String resultStatus;
  String memo;
  String result;

  AliPayResult(this.resultStatus, this.memo, this.result);
}
