import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../common/hl_app_theme.dart';
import '../../../common/hl_util.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/hl_view_tool.dart';
import '../../../local/hl_local.dart';
import 'hl_theme_controller.dart';

class HLThemePage extends StatefulWidget {
  HLThemePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HLThemePageState createState() => _HLThemePageState();
}
class _HLThemePageState extends State<HLThemePage> {

  HLThemeController hlThemeController = Get.put(HLThemeController());

  var itemList = [
    {"title": HLLocal.lightMode.tr},
    {"title": HLLocal.darkMode.tr} 
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
        itemBuilder: (c, i) => Obx(() => HLBusinessView.commonRow(
            context, appTheme, i, itemList[i]["title"].toString(), "",
            circular: Util.px(4),
            color: appTheme.themeColor,
            hasArrow: false,
            hasCheck: hlThemeController.isDark.value == i ? true : false,
            actionBlock: (index) {
              if (hlThemeController.isDark.value != index) {
                hlThemeController.isDark.value = index;
                appTheme.updateColors(index != 0);
              }
            })),
        itemCount: itemList.length,
      )
    );
  }

}
