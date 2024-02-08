import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hlflutter/module/guide/hl_guide_page.dart';

import '../../common/hl_util.dart';
import '../main/hl_tabBar_page.dart';

class HLLaunchController extends GetxController {

  jumpToMain() {
    // 初始化SharedPreferences
    Util.sharedPreInstance().then((value) {
      if (Util.isShowGuide() == true) {
        // 显示过引导页，跳转主页面
        Get.offAll(TabBarPage());
      } else {
        // 未显示过引导页，跳转引导页
        Get.offAll(const HLGuidePage());
        Util.showGuide();
      }
    });
  }

}
