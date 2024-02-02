import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../common/hl_app_theme.dart';
import '../../custom/hl_business_view.dart';
import '../../custom/hl_view_tool.dart';
import '../personal/hl_personal_controller.dart';

class HLPersonalPage extends StatelessWidget {
  // 第一种
  HLPersonalController personalController = Get.put(HLPersonalController());

  var itemList = [
    {"title": "收藏网站", "image": "images/personal/web.png"},
    {"title": "收藏文章", "image": "images/personal/wenjian.png"},
    {"title": "关于我们", "image": "images/personal/wenjian.png"},
    {"title": "设置", "image": "images/personal/wenjian.png"}
  ];

  HLPersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => HLBusinessView.commonRow(
            context,
            appTheme,
            i,
            itemList[i]["title"].toString(),
            itemList[i]["image"].toString().toString(),
            actionBlock: (index) {
              personalController.selItem(index);
            }),
        itemCount: itemList.length,
      ),
    );
  }
}
