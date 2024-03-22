import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/hl_app_theme.dart';
import '../../../common/hl_util.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/hl_view_tool.dart';
import '../set/hl_set_controller.dart';
import 'hl_collect_controller.dart';

class HLCollectPage extends StatefulWidget {
  const HLCollectPage({Key? key}) : super(key: key);

  @override
  State<HLCollectPage> createState() => _HLCollectPageState();
}

class _HLCollectPageState extends State<HLCollectPage> {
  HLCollectController collectController = Get.put(HLCollectController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collectController.getCollectArticles(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
        appBar: HLViewTool.appBar("我的收藏", appTheme, enableBack: true,
            backAction: () {
          collectController.back();
        }),
        backgroundColor: appTheme.backGroundColor,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const WaterDropHeader(),
          footer: CustomFooter(
            builder: (context, mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text("上拉加载更多");
              } else if (mode == LoadStatus.loading) {
                body = const CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = const Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("放开加载更多");
              } else {
                body = const Text("没有更多");
              }
              return SizedBox(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: collectController.refreshController,
          onRefresh: _onRefresh,
          onLoading: _loadMore,
          child: ListView.builder(
            itemBuilder: (c, i) => HLBusinessView.commonRow(
                context,
                appTheme,
                i,
                collectController.articles[i].title ?? "",
                collectController.articles[i].envelopePic ?? "",
                isTopFirst: true,
                hasArrow: false,
                isLoaclImage: false,
                actionBlock: (index) {}),
            itemCount: collectController.articles.length,
          ),
        ));
  }

  _onRefresh() {
    collectController.onRefresh(() {
      setState(() {});
    });
  }

  _loadMore() {
    collectController.loadMore(() {
      setState(() {});
    });
  }

}
