import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../common/hl_app_theme.dart';
import '../../../common/hl_util.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/hl_view_tool.dart';
import '../../../local/hl_local.dart';

class HLLanguagePage extends StatelessWidget {
  var itemList = [
    {"title": HLLocal.defaultLanguage.tr},
    {"title": HLLocal.languageZHHans.tr},
    {"title": HLLocal.languageZHHant.tr},
    {"title": HLLocal.languageEN.tr}
  ];

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar(HLLocal.languageSetting.tr, appTheme,
          enableBack: true, backAction: () {
            Get.back();
      }),
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => HLBusinessView.commonRow(
            context, appTheme, i, itemList[i]["title"].toString(), "",
            circular: Util.px(4),
            color: appTheme.themeColor, actionBlock: (index) {
          selItem(index, context, appTheme);
        }),
        itemCount: itemList.length,
      ),
    );
  }

  /// 设置语言页面选项
  selItem(int index, BuildContext context, AppTheme appTheme) {
    print('language selItem ${index}');
    if (index == 0) {
      // 跟随系统语言
      Locale deviceLocale = Get.deviceLocale!;
      print("---------------${deviceLocale}");
      print("---------------${deviceLocale.languageCode}");
      print("---------------${deviceLocale.countryCode}");

      if (deviceLocale.toString().contains("Hans")) {
        Get.updateLocale(const Locale("zh-Hans", "CN"));
        Util.setLanguage("zh-Hans");
      } else if (deviceLocale.toString().contains("Hant")) {
        Get.updateLocale(const Locale("zh-Hant", "CN"));
        Util.setLanguage("zh-Hant");
      } else {
        Get.updateLocale(deviceLocale);
        Util.setLanguage(deviceLocale.languageCode);
      }
    } else if (index == 1) {
      // 简体中文
      Get.updateLocale(const Locale("zh-Hans", "CN"));
      Util.setLanguage("zh-Hans");
    } else if (index == 2) {
      // 繁体中文
      Get.updateLocale(const Locale("zh-Hant", "CN"));
      Util.setLanguage("zh-Hant");
    } else {
      // 英文
      Get.updateLocale(const Locale("en", "US"));
      Util.setLanguage("en");
    }
  }

}
