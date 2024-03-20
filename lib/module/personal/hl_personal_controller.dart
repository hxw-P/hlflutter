import 'package:get/get.dart';

import '../../common/hl_router.dart';
import '../../common/hl_util.dart';

class HLPersonalController extends GetxController {

  /// 个人页面选项
  selItem(int index) {
    print('selItem ${index}');
    if (index == 0) {
      // 收藏网站
      if (Util.isLogin() == true) {
        // 已登录，跳转收藏页面
      }
      else {
        // 未登录，跳转登录
        Get.toNamed(HLRoutes.login);
      }
    }
    else if (index == 1) {
      // 收藏文章
      if (Util.isLogin() == true) {
        // 已登录，跳转收藏页面
      }
      else {
        // 未登录，跳转登录
        Get.toNamed(HLRoutes.login);
      }
    }
    else if (index == 2) {
      // 关于我们
      Get.toNamed("/web", arguments: {
        // 传参
        "url": "https://developer.huawei.com/consumer/cn/",
        "title": "关于我们"
      })?.then((value) {
        // 回参
        print("$value");
      });
    }
    else if (index == 3) {
      // 设置
      Get.toNamed(HLRoutes.set);
    }
  }

}