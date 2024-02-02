import 'package:get/get.dart';

import '../../common/hl_router.dart';

class HLPersonalController extends GetxController {

  /// 个人页面选项
  selItem(int index) {
    print('selItem ${index}');
    if (index == 0) {
    }
    else if (index == 1) {
    }
    else if (index == 2) {
    }
    else if (index == 3) {
      // 设置
      Get.toNamed(HLRoutes.set);
    }
  }

}