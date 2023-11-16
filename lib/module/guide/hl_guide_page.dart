import 'package:hlflutter/common/hl_util.dart';
import 'package:flutter/material.dart';
import 'package:hlflutter/module/guide/hl_single_guide_page.dart';
import 'package:hlflutter/custom/hl_view_tool.dart';

import '../main/hl_tabBar_page.dart';
import 'hl_indicator.dart';

//引导页
class HLGuidePage extends StatefulWidget {
  const HLGuidePage({super.key});

  @override
  HLGuidePageState createState() => HLGuidePageState();
}

class HLGuidePageState extends State<HLGuidePage> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PageView(
            //设置为水平滚动 并添加素材
            scrollDirection: Axis.horizontal,
            //翻页事件
            onPageChanged: startPagePaged,
            children: <Widget>[
              HLSingleGuidePage(
                  title: '小马盘',
                  subTitle: '用心搜集互联网公开资源',
                  imgPath: 'images/guide/guide_1.png'),
              HLSingleGuidePage(
                  title: '一键转存',
                  subTitle: '永久收藏到您的网盘',
                  imgPath: 'images/guide/guide_2.png'),
              HLSingleGuidePage(
                  title: '无痕搜索',
                  subTitle: '保护你的个人隐私',
                  imgPath: 'images/guide/guide_3.png'),
            ],
          ),
          currentPage == 2
              ? Positioned(
                  bottom: Util.px(32) + Util.bottomSafeHeight,
                  child: GestureDetector(
                    child: Column(
                      children: [
                        HLViewTool.createText(
                            text: '现在开始',
                            color: Util.rgbColor('#5F5EFF'),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        Container(
                          width: Util.px(20),
                          height: Util.px(20),
                          margin: EdgeInsets.fromLTRB(
                              Util.px(0), Util.px(30), Util.px(0), Util.px(0)),
                          child: Image.asset(
                            'images/guide/guide_start.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => TabBarPage()),
                        (route) => route == null,
                      );
                    },
                  ),
                )
              : Positioned(
                  bottom: Util.px(42) + Util.bottomSafeHeight,
                  child: HLIndicator(
                    currentPage: currentPage,
                    itemCount: 3,
                  ),
                ),
        ],
      ),
    );
  }

  void startPagePaged(int page) {
    print("--------$page");
    currentPage = page;
    setState(() {});
  }
}
