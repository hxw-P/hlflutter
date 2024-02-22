import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlflutter/module/entity/hl_user_entity.dart';
import 'package:provider/provider.dart';
import '../../common/hl_app_theme.dart';
import '../../common/hl_util.dart';
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
    HLUserEntity userInfo = Util.getUserInfo();
    return Scaffold(
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => i == 0
            ? HLBusinessView.personalHeader(userInfo, appTheme)
            : HLBusinessView.commonRow(
            context,
            appTheme,
            i - 1,
            itemList[i - 1]["title"].toString(),
            itemList[i - 1]["image"].toString().toString(),
            circular: Util.px(4),
            color: appTheme.themeColor,
            actionBlock: (index) {
              personalController.selItem(index);
            }),
        itemCount: itemList.length + 1,
      ),
    );
  }


}
