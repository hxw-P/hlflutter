import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/hl_app_theme.dart';
import '../../../custom/hl_view_tool.dart';

class HLNotiPage extends StatefulWidget {
  const HLNotiPage({Key? key}) : super(key: key);

  @override
  State<HLNotiPage> createState() => _HLNotiPageState();
}

class _HLNotiPageState extends State<HLNotiPage> {
  @override
  void initState() {
    //监听Widget是否绘制完毕
    WidgetsBinding.instance.addPostFrameCallback(_getRenderBox);
    super.initState();
  }

  //定义一个key
  GlobalKey _key = GlobalKey();

  _getRenderBox(_) {
    print("_getRenderBox");
    final RenderBox? renderBoxRed = _key.currentContext!.findRenderObject() as RenderBox?;
    final sizeRed = renderBoxRed?.size;
    //输出背景为红色的widget的宽高
    print("size of red:$sizeRed");
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar("通知", appTheme, enableBack: true, actions: [],
          backAction: () {
        Navigator.of(context).pop();
      }),
      body: Container(
        key: _key,
        alignment: Alignment.center,
        child: HLViewTool.createText(
            text: "功能暂未开发",
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
