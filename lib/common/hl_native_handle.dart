import 'package:flutter/services.dart';

class HLNativeHandle {

  // 原生交互通道
  static const platform = MethodChannel('com.hl.native');

  // 与原生交互
  static Future<void> exchangeWithNative(Map<String, String> params) async {
    final String result = await platform.invokeMethod('exchangeWithNative', params);
    print('$result');
  }

}