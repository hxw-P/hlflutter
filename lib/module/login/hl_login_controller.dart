import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hlflutter/common/hl_router.dart';
import 'package:provider/provider.dart';
import '../../common/hl_app_theme.dart';
import '../../custom/hl_toast.dart';
import '../../net/hl_api.dart';
import '../../net/hl_http_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HLLoginController extends GetxController {

  // 是否勾选隐私协议
  RxBool selPrivacy = RxBool(true);

  /// 登录
  login(BuildContext context, AppTheme appTheme,String username, String passwod, Function complete) async{
    EasyLoading.show(status: 'loading...');
    // 同时加载在线数据
    HLHttpClient.getInstance().post(Api.post_login, params: {'username': username, 'password': passwod}, context: context, successCallBack: (data) {
      EasyLoading.dismiss();
      Get.toNamed(HLRoutes.main);
    }, errorCallBack: (code, msg) {
      // HLToast.toast(context, msg: 'fsdfds');
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: appTheme.toastBackColor,
          textColor: appTheme.toastTitleColor,
          fontSize: 16.0,
      );
    });
  }

  /// 跳转web页面
  pushWeb(String action) {
    Get.toNamed(HLRoutes.web, arguments: {
      "url": "https://www.baidu.com",
      "title": action
    });
  }

  /// 切换隐私协议按钮选中状态
  changePrivacySelState() {
    if (selPrivacy.value) {
      selPrivacy.value = false;
    }
    else {
      selPrivacy.value = true;
    }
  }

}