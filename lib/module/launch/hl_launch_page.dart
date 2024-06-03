import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/hl_util.dart';
import '../guide/hl_guide_page.dart';
import '../main/hl_tabBar_page.dart';

class HLLaunchPage extends StatefulWidget {
  const HLLaunchPage({super.key});

  @override
  State<HLLaunchPage> createState() => _HLLaunchPageState();
}

class _HLLaunchPageState extends State<HLLaunchPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => jumpToMain());
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

  jumpToMain() {
    if (Util.isShowGuide() == true) {
      // 显示过引导页，跳转主页面
      Get.offAll(TabBarPage());
    } else {
      // 未显示过引导页，跳转引导页
      Get.offAll(const HLGuidePage());
      Util.showGuide();
    }
  }

}
