import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../common/hl_app_theme.dart';
import '../../../common/hl_router.dart';
import '../../../common/hl_util.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/hl_view_tool.dart';
import '../../../local/hl_local.dart';
import '../../../net/hl_api.dart';
import '../../../net/hl_http_client.dart';
import '../../main/hl_tabBar_page.dart';

class HLSetPage extends StatelessWidget {
  var itemList = [
    {"title": HLLocal.languageSetting.tr},
    {"title": HLLocal.themeSet.tr},
    {"title": HLLocal.logout.tr},
  ];

  HLSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar(HLLocal.set.tr, appTheme, enableBack: true,
          backAction: () {
        back();
      }),
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => HLBusinessView.commonRow(
            context, appTheme, i, itemList[i]["title"].toString(), "",
            isTopFirst: true, actionBlock: (index) {
          selItem(index, context, appTheme);
        }),
        itemCount: itemList.length,
      ),
    );
  }

  /// 设置页面选项
  selItem(int index, BuildContext context, AppTheme appTheme) {
    print('set selItem ${index}');
    if (index == 0) {
      // 语言设置
      Get.toNamed(HLRoutes.language);
    } else if (index == 1) {
      // 主题设置
      Get.toNamed(HLRoutes.theme);
    } else {
      // 退出登录
      logout(context, appTheme);
    }
  }

  /// 退出登录
  logout(BuildContext context, AppTheme appTheme) {
    EasyLoading.show(status: 'loading...');
    HLHttpClient.getInstance().get(Api.get_logout,
        successCallBack: (data) async {
      // 设置退出登录标识
      Util.loginOutSuccess();
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

  back() {
    Get.back();
  }
}
