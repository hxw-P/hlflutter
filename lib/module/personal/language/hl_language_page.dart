import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../common/hl_app_theme.dart';
import '../../../common/hl_util.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/hl_view_tool.dart';
import '../../../local/hl_local.dart';
import 'hl_language_controller.dart';

class HLLanguagePage extends StatelessWidget {
  HLLanguageController languageController = Get.put(HLLanguageController());

  var itemList = [
    {"title": HLLocal.defaultLanguage.tr},
    {"title": HLLocal.languageZHHans.tr},
    {"title": HLLocal.languageZHHant.tr},
    {"title": HLLocal.languageEN.tr}
  ];

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar(HLLocal.languageSetting.tr, appTheme, enableBack: true, backAction: () {
        languageController.back();
      }),
      backgroundColor: appTheme.backGroundColor,
      body: ListView.builder(
        itemBuilder: (c, i) => HLBusinessView.commonRow(
            context,
            appTheme,
            i,
            itemList[i]["title"].toString(),
            "",
            circular: Util.px(4),
            color: appTheme.themeColor, actionBlock: (index) {
          languageController.selItem(index, context, appTheme);
        }),
        itemCount: itemList.length,
      ),
    );
  }
}
