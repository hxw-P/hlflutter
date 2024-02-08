import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hlflutter/custom/hl_business_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../common/hl_app_theme.dart';
import '../../common/hl_util.dart';
import '../../custom/hl_view_tool.dart';
import '../../db/hl_db_manager.dart';
import '../../net/hl_api.dart';
import '../../net/hl_http_client.dart';
import '../entity/hl_project_entity.dart';

class HLProjectPage extends StatefulWidget {

  // const HLProjectPage({Key? key}) : super(key: key);

  @override
  _HLProjectPageState createState() => _HLProjectPageState();
}

class _HLProjectPageState extends State<HLProjectPage> with AutomaticKeepAliveClientMixin<HLProjectPage> {
  List<HLProjectEntity> projects = [];
  int currentPage = 0;

  static const paltform = const MethodChannel("myapp.goToNativePage");
  late ScrollController _gridViewController;

  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<void> _goToNativePage() async {
    try {
      final int result = await paltform
          .invokeMethod('goToNativePage', {'test': 'from flutter'});
      print(result);
    } on PlatformException catch (e) {}
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gridViewController = ScrollController()
      ..addListener(() {
        print('${_gridViewController.position}');
      });

    getProjects();
  }



  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar("项目", appTheme),
      body: SmartRefresher(controller: _refreshController,
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
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: projects.isNotEmpty ?
        StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: projects.length,
          itemBuilder: (BuildContext context, int index) => Container(
            child: HLBusinessView.projectGrid(context, appTheme, index, projects[index], actionBlock: () {
              goProjectDetail(index);
            }),
          ),
          staggeredTileBuilder: (int index) => StaggeredTile.count(1, index == 0 ? 1 : 1.5),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 4.0,
        )
            : Align(
          alignment: const Alignment(0, -0.2),
          child: Platform.isIOS
              ? const CupertinoActivityIndicator()
              : const CircularProgressIndicator(
              backgroundColor: Colors.orange),
        ),
      ),
      );
  }

  /// 点击跳转项目详情
  goProjectDetail(int index) {
    // MaterialPageRoute 方式跳转
    Navigator.pushNamed(context, "/web", arguments: {
      // 传参
      "url": projects[index].link ?? "",
      "title": projects[index].title ?? ""
    },).then((value) {
      // 回参
      print("$value");
    });
  }

  /// 下拉刷新
  void _onRefresh() {
    currentPage = 0;
    getProjects();
  }

  /// 上拉加载更多
  void _onLoading() {
    currentPage++;
    getProjects();
  }

  Widget getPlatformTextView() {
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return AndroidView(
    //       viewType: "platform_text_view",
    //       creationParams: <String, dynamic>{"text": "Android Text View"},
    //       creationParamsCodec: const StandardMessageCodec());
    // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return UiKitView(
        viewType: "platform_text_view",
        creationParams: <String, dynamic>{"text": "iOS Label"},
        creationParamsCodec: const StandardMessageCodec());
    // } else {
    //   return Text("Not supported");
    // }
  }

  getProjects() {
    HLHttpClient.getInstance().get("${Api.get_listprojects}$currentPage/json",
        context: context, successCallBack: (data) {
          List responseJson = data["datas"];
          print("获取项目列表 == $responseJson");
          List<HLProjectEntity> newProjects = responseJson.map((m) {
            HLProjectEntity entity = HLProjectEntity.fromJson(m);
            HLDBManager.getInstance()?.openDb().then((value) {
              HLDBManager.getInstance()?.insertItem(entity).then((value) {});
            });
            return entity;
          }).toList();

          if (currentPage == 0) {
            //下拉刷新
            projects = newProjects;
            _refreshController.refreshCompleted();
          } else {
            //上拉加载更多
            projects.addAll(newProjects);
            _refreshController.loadComplete();
          }
          setState(() {});
        }, errorCallBack: (code, msg) {
          // 请求失败使用缓存
          HLDBManager.getInstance()?.openDb().then((value) {
            HLDBManager.getInstance()?.queryItems(HLProjectEntity()).then((value) {
              // isFirstLoad = false;
              // articles = value;
              // setState(() {});
            });
          });
        });
  }
}
