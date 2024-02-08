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
    HLUserEntity userInfo = Util.setUserInfo({});
    return Scaffold(
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => i == 0
            ? personalHeader(userInfo, appTheme)
            : HLBusinessView.commonRow(
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

  personalHeader(HLUserEntity userInfo, AppTheme appTheme) {
    return Row(
      children: [
        Image.asset('images/personal/head.png',
            width: Util.px(20), height: Util.px(20)),
        Column(
          children: [
            HLViewTool.createText(
                text: "${userInfo.userName}",
                color: appTheme.titleColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            HLViewTool.createText(
                text: "${userInfo.email}",
                color: appTheme.subTitleDarkColor,
                fontSize: 14,
                fontWeight: FontWeight.normal)
          ],
        )
      ],
    );
  }
}
