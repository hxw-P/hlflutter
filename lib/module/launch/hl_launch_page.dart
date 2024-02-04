import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/hl_util.dart';
import 'hl_launch_controller.dart';

class HLLaunchPage extends StatefulWidget {
  const HLLaunchPage({super.key});

  @override
  State<HLLaunchPage> createState() => _HLLaunchPageState();
}

class _HLLaunchPageState extends State<HLLaunchPage> {
  HLLaunchController launchController = Get.put(HLLaunchController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 跳转主页面
    launchController.jumpToMain();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: Util.px(250),
        height: Util.px(250),
        child: Image.asset('images/launch/launch_icon.png'),
      ),
    );
  }
}
