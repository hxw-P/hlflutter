import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// page
import 'package:hlflutter/module/home/page/hl_home_page.dart';
import 'package:hlflutter/module/personal/hl_personal_page.dart';
import 'package:hlflutter/module/project/hl_project_page.dart';
import 'package:hlflutter/common/hl_util.dart';
import 'package:hlflutter/common/hl_app_theme.dart';
import 'package:provider/provider.dart';

class TabBarPage extends StatefulWidget {

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  /// 当前索引
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  /// 子控制器
  final pages = [HLHomePage(title: "首页"), HLProjectPage(), HLPersonalPage()];

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Material(
      child: Container(
        color: appTheme.backGroundColor,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                children: pages,
                physics: NeverScrollableScrollPhysics(), // 禁止滑动
              ),
            ),
            Container(
                color: appTheme.backColor,
                padding: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).padding.bottom),
                child: Column(
                  children: [
                    Container(
                      color: appTheme.bottomDividerColor,
                      height: Util.px(0.5),
                    ),
                    Row(
                        children: <Widget>[
                          createBottomAppBarItem(
                              0,
                              "首页",
                              currentIndex == 0
                                  ? "images/bottom_tabbar/shouye_sel.png"
                                  : "images/bottom_tabbar/shouye_nor.png",
                              appTheme),
                          createBottomAppBarItem(
                              1,
                              "项目",
                              currentIndex == 1
                                  ? "images/bottom_tabbar/guangchang_sel.png"
                                  : "images/bottom_tabbar/guangchang_nor.png",
                              appTheme),
                          createBottomAppBarItem(
                              2,
                              "我的",
                              currentIndex == 2
                                  ? "images/bottom_tabbar/yonghu_sel.png"
                                  : "images/bottom_tabbar/yonghu_nor.png",
                              appTheme),
                        ]
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  ///创建底部BarItem
  createBottomAppBarItem(
      int index, String title, String iconPath, AppTheme appTheme) {
    TextStyle textStyle = TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: index == currentIndex
            ? appTheme.bottomAppbarSelColor
            : appTheme.bottomAppbarNorColor);
    Widget item = Expanded(
      flex: 1,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, Util.px(3), 0, Util.px(3)),
          color: appTheme.backColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: Util.px(25),
                child: Image.asset(iconPath),
              ),
              Text(title, style: textStyle),
            ],
          ),
        ),
        onTap: () {
          changeBottomAppBarItem(index);
        },
      ),
    );
    return item;
  }

  ///切换BottomAppBar选项
  changeBottomAppBarItem(int selectIndex) {
    if (currentIndex != selectIndex) {
      pageController.jumpToPage(selectIndex);
      currentIndex = selectIndex;
      setState(() {});
    }
  }
}
