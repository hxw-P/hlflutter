import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hlflutter/custom/hl_view_tool.dart';
import 'package:hlflutter/custom/hl_toast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../common/hl_app_theme.dart';
import '../../../common/hl_util.dart';
import '../../../custom/hl_business_view.dart';
import '../../../custom/popup/hl_popupwindow.dart';
import '../../../db/hl_db_manager.dart';
import '../../../net/hl_api.dart';
import '../../../net/hl_http_client.dart';
import '../entity/hl_article_entity.dart';
import '../entity/hl_banner_entity.dart';
import 'hl_article_detail_page.dart';

class HLHomePage extends StatefulWidget {
  const HLHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HLHomePage> createState() => _HLHomePageState();
}

class _HLHomePageState extends State<HLHomePage>
    with AutomaticKeepAliveClientMixin {
  List<HLArticleEntity> articles = [];
  List<HLBannerEntity> banners = [];
  bool isShowRefresh = false;
  int currentPage = 0;
  final GlobalKey _targetKey = GlobalKey();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  //1.必须with  AutomaticKeepAliveClientMixin;
  //2.实现get wantKeepAlive方法.当前页面需要缓存到的时候返回true,否则返回flase.默认是flase
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// addPostFrameCallback是StatefulWidget渲染结束之后的回调，只会调用一次，一般是在initState里添加回调：，
    // WidgetsBinding.instance.addPostFrameCallback((_) {});
    getArticles();
    getBanners();
  }

  /// 下拉刷新
  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    currentPage = 0;
    getArticles();
    getBanners();
  }

  /// 上拉加载更多
  void _onLoading() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use loadFailed(),if no data return,use LoadNodata()
    // // items.add((items.length+1).toString());
    // if(mounted)
    //   setState(() {
    //
    //   });
    currentPage++;
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    var popItemList = [
      {"title": "消息", "image": "images/home/xiaoxi.png"},
      {"title": "通知", "image": "images/home/tongzhi.png"},
      {"title": "编辑", "image": "images/home/bianji.png"},
    ];
    return Scaffold(
      // appBar: HLViewHanlde.appBar("title", appTheme,
      // titleView: searchTextView(appTheme),
      //   centerTitle: false,
      //   actions: [
      //     Container(
      //       alignment: Alignment.centerLeft,
      //       width: 33,
      //       child: HLViewHanlde.createText(text: "text", color: appTheme.titleColor, fontSize: 14, fontWeight: FontWeight.w400),
      //     )
      //   ],),
      backgroundColor: appTheme.grayBackColor,
      appBar: HLViewTool.appBar("首页", appTheme, actions: [
        HLViewTool.createAppBarAction("images/home/sousuo.png", appTheme,
            action: () {
          Navigator.pushNamed(context, "noti_page", arguments: {});
        }),
        HLViewTool.createAppBarAction("images/home/tianjia.png", appTheme,
            key: _targetKey, action: () {
          HLPopupWindow.showPopWindow(
            context,
            popSize: const Size(150, 120),
            targetKey: _targetKey,
            // popWidget: GestureDetector(
            //   child: Container(
            //     color: Colors.red,
            //     width: 150,
            //     height: 120,
            //   ),
            //   onTap: () {
            //     print("Container");
            //     Navigator.pop(context);
            //   },
            // ),
            popWidget: HLViewTool.createList(
              appTheme,
                popItemList,
              width: 150,
              height: 120,
              itemHeight: 40,
              actionBlock: (index) {
                print("fsdfsdsdfsdfsd");
                Navigator.pop(context);
                // HLToast.toast(context, msg: popItemList[index]["title"].toString());
              }
            ),
            offset: const Offset(-65, 0),
          );
        })
      ]),
      body: articles.isNotEmpty && banners.isNotEmpty
          ? SmartRefresher(
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
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemBuilder: (c, i) => i == 0
                    ? Container(
                        height: Util.px(230),
                        margin: EdgeInsets.fromLTRB(0, Util.px(10), 0, 0),
                        child: Swiper(
                          // 主轴上和父视图的比例
                          viewportFraction: 0.92,
                          // 每个item整体缩放比例
                          scale: 0.75,
                          autoplay: false,
                          itemCount: banners.length,
                          pagination: const SwiperPagination(
                              margin: EdgeInsets.fromLTRB(0, 0, 20, 4),
                              alignment: Alignment(1.0, 1.0)),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: HLViewTool.createDecoration(
                                  borderColor: Colors.white,
                                  contentColor: Colors.white,
                                  radius: 10,
                                  enableShadow: false),
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      child: Image.network(
                                          banners[index].imagePath!,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          Util.px(5), 0, 0, 0),
                                      height: Util.px(23),
                                      color: Colors.black38,
                                      alignment: Alignment.centerLeft,
                                      child: HLViewTool.createText(
                                          text: banners[index].title!,
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          onTap: (int index) {
                            Navigator.pushNamed(context, "web_page",
                                arguments: {
                                  "url": banners[index].url ?? "",
                                  "title": banners[index].title ?? ""
                                });
                          },
                        ),
                      )
                    : HLBusinessView.articleRow(
                        c, appTheme, i - 1, articles[i - 1], actionBlock: () {
                        print("点击cell");
                        // var params = Map<String, String>.from({"url": articles[i].link ?? "", "title": articles[i].title ?? ""});
                        Navigator.pushNamed(context, "web_page", arguments: {
                          "url": articles[i - 1].link ?? "",
                          "title": articles[i - 1].title ?? ""
                        });
                        // Navigator.of(context)
                        //     .push(CupertinoPageRoute(builder: (_) {
                        //   return ArticleDetailPage();
                        // }));
                      }),
                // 高度设置就是固定的了
                // itemExtent: 200.0,
                itemCount: articles.length + 1,
              ),
            )
          : Align(
              alignment: const Alignment(0, -0.2),
              child: Platform.isIOS
                  ? const CupertinoActivityIndicator()
                  : const CircularProgressIndicator(
                      backgroundColor: Colors.orange),
            ),
    );
  }

  /// 创建搜索框
  searchTextView(AppTheme appTheme) {
    return Container(
      height: Util.px(30),
      decoration: HLViewTool.createDecoration(
          borderColor: appTheme.borderColor,
          contentColor: Colors.white,
          radius: 6),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: Util.px(18),
            color: Colors.grey,
          ),
          Text(
            "请输入搜索内容",
            style: TextStyle(
              fontSize: Util.px(12),
              color: appTheme.subTitleColor,
            ),
          )
        ],
      ),
    );
  }

  ///获取主页文章
  getArticles() async {
    HLHttpClient.getInstance().get("${Api.get_articles}$currentPage/json",
        context: context, successCallBack: (data) {
      List responseJson = data["datas"];
      print("获取主页文章 == $responseJson");
      List<HLArticleEntity> newArticles = responseJson.map((m) {
        HLArticleEntity entity = HLArticleEntity.fromJson(m);
        HLDBManager.getInstance()?.openDb().then((value) {
          HLDBManager.getInstance()?.insertItem(entity).then((value) {});
        });
        return entity;
      }).toList();

      if (currentPage == 0) {
        //下拉刷新
        articles = newArticles;
        _refreshController.refreshCompleted();
      } else {
        //上拉加载更多
        articles.addAll(newArticles);
        _refreshController.loadComplete();
      }
      if (banners.isNotEmpty) {
        setState(() {});
      }
    }, errorCallBack: (code, msg) {
      // 请求失败使用缓存
      HLDBManager.getInstance()?.openDb().then((value) {
        HLDBManager.getInstance()?.queryItems(HLArticleEntity()).then((value) {
          // isFirstLoad = false;
          // articles = value;
          // setState(() {});
        });
      });
    });
  }

  ///获取主页轮播
  getBanners() async {
    print("获取主页轮播列表 1");
    HLHttpClient.getInstance().get(Api.get_banners, context: context,
        successCallBack: (data) {
      List responseJson = data;
      print("获取主页轮播列表 == $responseJson");
      List<HLBannerEntity> newBanners = responseJson.map((m) {
        print("主页轮播 == $m");
        HLBannerEntity entity = HLBannerEntity.fromJson(m);
        print("主页轮播 fromJson");
        HLDBManager.getInstance()?.openDb().then((value) {
          HLDBManager.getInstance()?.insertItem(entity).then((value) {
            print("添加成功");
          });
        });
        return entity;
      }).toList();
      print("主页轮播 toList");
      banners = newBanners;
      if (articles.isNotEmpty) {
        setState(() {});
      }
    }, errorCallBack: (code, msg) {
      // 请求失败使用缓存
      HLDBManager.getInstance()?.openDb().then((value) {
        HLDBManager.getInstance()?.queryItems(HLBannerEntity()).then((value) {
          // articles = value;
          // setState(() {});
        });
      });
    });
  }
}
