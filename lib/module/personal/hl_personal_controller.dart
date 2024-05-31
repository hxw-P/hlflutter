import 'package:get/get.dart';

import '../../common/hl_router.dart';
import '../../common/hl_util.dart';
import '../../local/hl_local.dart';

class HLPersonalController extends GetxController {

  /// 个人页面选项
  selItem(int index) {
    print('personal selItem ${index}');
    if (index == 0) {
      // 收藏文章
      if (Util.isLogin() == true) {
        // 已登录，跳转收藏页面
        Get.toNamed(HLRoutes.collect);
      }
      else {
        // 未登录，跳转登录
        Get.toNamed(HLRoutes.login);
      }
    }
    else if (index == 1) {
      // 关于我们
      Get.toNamed("/web", arguments: {
        // 传参
        "url": "https://developer.huawei.com/consumer/cn/",
        "title": HLLocal.aboutUS.tr
      })?.then((value) {
        // 回参
        print("$value");
      });
    }
    else if (index == 2) {
      // 设置
      if (Util.isLogin() == true) {
        // 已登录，跳转设置页面
        Get.toNamed(HLRoutes.set);
      }
      else {
        // 未登录，跳转登录
        Get.toNamed(HLRoutes.login);
      }
    }
  }

}