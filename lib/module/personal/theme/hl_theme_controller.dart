import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../common/hl_util.dart';

class HLThemeController extends GetxController {

  // 是否深色模式
  RxInt isDark = RxInt(Util.getIsDark());

}
