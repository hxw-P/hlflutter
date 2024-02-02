import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/hl_app_theme.dart';
import '../../../common/hl_router.dart';
import '../../../net/hl_api.dart';
import '../../../net/hl_cookie_handle.dart';
import '../../../net/hl_http_client.dart';
import '../../main/hl_tabBar_page.dart';

class HLSetController extends GetxController {

  logout(BuildContext context, AppTheme appTheme) {
    EasyLoading.show(status: 'loading...');
    HLHttpClient.getInstance().get(Api.get_logout,
        context: context, successCallBack: (data) async {
          // 请求成功
          // 清除cookie
          await CookieHandle.delete();
          EasyLoading.dismiss();
          Fluttertoast.showToast(
            msg: '退出登录成功',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: appTheme.toastBackColor,
            textColor: appTheme.toastTitleColor,
            fontSize: 16.0,
          );
          // 跳转主页面
          Get.offAll(TabBarPage());
        }, errorCallBack: (code, msg) {
          // 请求失败
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
}
