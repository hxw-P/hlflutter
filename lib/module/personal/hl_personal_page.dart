import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlflutter/local/hl_local.dart';
import 'package:hlflutter/module/entity/hl_user_entity.dart';
import 'package:provider/provider.dart';
import '../../common/hl_app_theme.dart';
import '../../common/hl_util.dart';
import '../../custom/hl_business_view.dart';
import '../../custom/hl_view_tool.dart';
import '../personal/hl_personal_controller.dart';

class HLPersonalPage extends StatefulWidget {
  const HLPersonalPage({super.key});

  // const HLProjectPage({Key? key}) : super(key: key);

  @override
  _HLPersonalPageState createState() => _HLPersonalPageState();
}

class _HLPersonalPageState extends State<HLPersonalPage> with AutomaticKeepAliveClientMixin<HLPersonalPage> {
  // 第一种
  HLPersonalController personalController = Get.put(HLPersonalController());

  var itemList = [
    {"title": HLLocal.collect.tr, "image": "images/personal/wenjian.png"},
    {"title": HLLocal.aboutUS.tr, "image": "images/personal/about.png"},
    {"title": HLLocal.set.tr, "image": "images/personal/set.png"}
  ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
            itemList[i - 1]["image"].toString(),
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
