import 'dart:convert';

import 'package:flutter/services.dart';

class HLNativeHandle {

  // 原生交互通道
  static const platform = MethodChannel('com.hl.native');

  // 与原生交互
  static void exchangeWithNative(String method, Map<String, String> params, Function complete) async {
    // 返回值为{"code": "1", ...其他参数}  code 1成功，0失败
    // Future future = await platform.invokeMethod(method, params);
    //
    // future.then((result) {
    //
    //   if (result["code"] == "1") {
    //     print("MethodChannel-$method:成功");
    //   }
    //   else {
    //     print("MethodChannel-$method:失败");
    //   }
    //   if (complete != null) {
    //     complete(result);
    //   }
    // });

    String response = await platform.invokeMethod(method, params);
    print("MethodChannel-$response");
    Map<String, dynamic> result  = jsonDecode(response);
    if (result["code"] == "1") {
      print("MethodChannel-$method:成功");
    }
    else {
      print("MethodChannel-$method:失败");
    }
    if (complete != null) {
      complete(result);
    }
  }

}