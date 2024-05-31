import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hlflutter/common/hl_util.dart';

import '../../../common/hl_app_theme.dart';

class HLLanguageController extends GetxController {

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
      }
      else if (deviceLocale.toString().contains("Hant")) {
        Get.updateLocale(const Locale("zh-Hant", "CN"));
        Util.setLanguage("zh-Hant");
      }
      else {
        Get.updateLocale(deviceLocale);
        Util.setLanguage(deviceLocale.languageCode);
      }
    }
    else if (index == 1) {
      // 简体中文
      Get.updateLocale(const Locale("zh-Hans", "CN"));
      Util.setLanguage("zh-Hans");
    }
    else if (index == 2) {
      // 繁体中文
      Get.updateLocale(const Locale("zh-Hant", "CN"));
      Util.setLanguage("zh-Hant");
    }
    else {
      // 英文
      Get.updateLocale(const Locale("en", "US"));
      Util.setLanguage("en");
    }
  }

  back() {
    Get.back();
  }

}