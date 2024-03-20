// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/hl_app_theme.dart';
import '../../common/hl_util.dart';
import 'package:hlflutter/custom/hl_view_tool.dart';

class HLSingleGuidePage extends StatefulWidget {
  String title = "";
  String subTitle = "";
  late String imgPath;

  HLSingleGuidePage({Key? key, required this.title, required this.subTitle, required this.imgPath}) : super(key: key);


  @override
  HLSingleGuidePageState createState() => HLSingleGuidePageState();
}

class HLSingleGuidePageState extends State<HLSingleGuidePage> {

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: Util.px(240),
          height: Util.px(221),
          child: Image.asset(widget.imgPath),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              Util.px(0), Util.px(43), Util.px(0), Util.px(0)),
          child: HLViewTool.createText(
              text: widget.title,
              color: appTheme.titleColor,
              fontSize: 24,
              fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              Util.px(0), Util.px(0), Util.px(0), Util.px(0)),
          child: HLViewTool.createText(
              text: widget.subTitle,
              color: appTheme.titleColor,
              fontSize: 24,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
