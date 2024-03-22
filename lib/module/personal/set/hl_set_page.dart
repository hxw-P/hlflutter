import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../common/hl_app_theme.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/hl_view_tool.dart';
import 'hl_set_controller.dart';

class HLSetPage extends StatelessWidget {
  // 第一种
  HLSetController setController = Get.put(HLSetController());

  var itemList = [
    {"title": "退出登录", "image": "images/personal/logout.png"},
  ];

  HLSetPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar("设置", appTheme, enableBack: true, backAction: () {
        setController.back();
      }),
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => HLBusinessView.commonRow(
            context,
            appTheme,
            i,
            itemList[i]["title"].toString(),
            itemList[i]["image"].toString().toString(),
          isTopFirst: true,
          actionBlock: (index) {
            setController.logout(context, appTheme);
          }),
        itemCount: itemList.length,
      ),
    );
  }
}