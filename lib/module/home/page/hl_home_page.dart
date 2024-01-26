import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hlflutter/common/hl_native_handle.dart';
import 'package:hlflutter/custom/hl_view_tool.dart';
import 'package:hlflutter/custom/hl_toast.dart';
import 'package:hlflutter/db/hl_db_base_entity.dart';
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
    getBanners();
    getArticles();
  }

  /// 下拉刷新
  void _onRefresh() {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    currentPage = 0;
    getArticles();
    getBanners();
  }

  /// 上拉加载更多
  void _onLoading() {
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
            popWidget: HLViewTool.createList(appTheme, popItemList,
                width: 150, height: 120, itemHeight: 40, actionBlock: (index) {
              Navigator.pop(context);
              HLNativeHandle.exchangeWithNative(
                  "push",
                  {
                    "msg": popItemList[index]["title"].toString(),
                    "router": "/test"
                  },
                  (result) {});
              // HLToast.toast(context, msg: popItemList[index]["title"].toString());
            }),
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
                            goBannaerDetail(index);
                          },
                        ),
                      )
                    : HLBusinessView.articleRow(
                        c, appTheme, i - 1, articles[i - 1], actionBlock: (action) {
                          if (action == ArticleAction.detail) {
                            // 进入详情
                            goArticleDetail(i - 1);
                          }
                          else if (action == ArticleAction.collect || action == ArticleAction.cancelCollect) {
                            // 收藏、取消收藏文章
                            collect(articles[i - 1]);
                          }
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

  /// 点击跳转文章详情
  goArticleDetail(int index) {
    //Getx 方式跳转
    Get.toNamed("/web", arguments: {
      // 传参
      "url": articles[index].link ?? "",
      "title": articles[index].title ?? ""
    })?.then((value) {
      // 回参
      print("$value");
    });
  }

  /// 点击跳转banner详情
  goBannaerDetail(int index) {
    //Getx 方式跳转
    Get.toNamed("/web", arguments: {
      // 传参
      "url": banners[index].url ?? "",
      "title": banners[index].title ?? ""
    })?.then((value) {
      // 回参
      print("$value");
    });
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
    // 先显示缓存数据
    // await HLDBManager.getInstance()?.openDb().then((value) async {
    //   await HLDBManager.getInstance()?.queryItems(HLArticleEntity()).then((value) {
    //     print("getArticles${value?.length}");
    //     articles = value!.map((e) {
    //       HLArticleEntity entity = e as HLArticleEntity;
    //       return entity;
    //     }).toList();
    //   });
    // });
    // if (articles.isNotEmpty&&banners.isNotEmpty) {
    //   setState(() {});
    // }
    // 同时加载在线数据
    HLHttpClient.getInstance().get("${Api.get_articles}$currentPage/json",
        context: context, successCallBack: (data) async {
          List responseJson = data["datas"];
          if (responseJson.isNotEmpty) {
            List<HLArticleEntity> newArticles = [];
            await handleResponseJson(HLArticleEntity(), responseJson).then((value) {
              newArticles = value!.map((e) {
                HLArticleEntity entity = e as HLArticleEntity;
                print('--------------------${entity.collect}');
                return entity;
              }).toList();
            });
            if (currentPage == 0) {
              //下拉刷新
              articles = newArticles;
              _refreshController.refreshCompleted();
            } else {
              //上拉加载更多
              articles.addAll(newArticles);
              _refreshController.loadComplete();
            }
            if (articles.isNotEmpty&&banners.isNotEmpty) {
              setState(() {});
            }
          }
        }, errorCallBack: (code, msg) {
          // 请求失败
        });
  }

  Future<List<HLDbBaseEntity>?> handleResponseJson<T extends HLDbBaseEntity>(T t, List list) async {
    List<HLDbBaseEntity> newList = [];
    // 更新数据库缓存(移除旧数据)
    print("test-测试异步1");
    await HLDBManager.getInstance()?.openDb().then((value) async {
      await HLDBManager.getInstance()?.deleteItem(t).then((value) {
        // 处理文章数据map->model
        print("test-测试异步2");
        newList = list.map((m) {
          print('--------------------${m['collect']}');
          HLDbBaseEntity entity = t.fromMap(m);
          // 更新数据库缓存(插入新数据)
          HLDBManager.getInstance()?.openDb().then((value) {
            HLDBManager.getInstance()?.insertItem(entity).then((value) {});
          });
          return entity;
        }).toList();
      });
    });
    print("test-测试异步3");
    print("test-openDb和deleteItem两个future之前都需要添加await才可以最终打印测试异步123");
    return newList;
  }

  ///获取主页轮播
  getBanners() async{
    // 先显示缓存数据
    // await HLDBManager.getInstance()?.openDb().then((value) async {
    //   await HLDBManager.getInstance()?.queryItems(HLBannerEntity()).then((value) {
    //     print("getBanners${value?.length}");
    //     if (banners.isEmpty&&value!=null) {
    //       banners = value!.map((e) {
    //         HLBannerEntity entity = e as HLBannerEntity;
    //         return entity;
    //       }).toList();
    //     }
    //   });
    // });
    // if (articles.isNotEmpty&&banners.isNotEmpty) {
    //   setState(() {});
    // }
    // 同时加载在线数据
    HLHttpClient.getInstance().get(Api.get_banners, context: context,
        successCallBack: (data) async {
      List responseJson = data;
      if (responseJson.isNotEmpty) {
        await handleResponseJson(HLBannerEntity(), responseJson).then((value) {
          banners = value!.map((e) {
            HLBannerEntity entity = e as HLBannerEntity;
            return entity;
          }).toList();
        });
        print("net-get_banners:$banners");
        if (articles.isNotEmpty&&banners.isNotEmpty) {
          setState(() {});
        }
      }
    }, errorCallBack: (code, msg) {
      // 请求失败
    });
  }

  ///收藏
  collect(HLArticleEntity articleEntity) {
    HLHttpClient.getInstance().post("${Api.post_collect_article}${articleEntity.id}/json", context: context,
        successCallBack: (data) async {
          // List responseJson = data;
          // if (responseJson.isNotEmpty) {
          //   await handleResponseJson(HLBannerEntity(), responseJson).then((value) {
          //     banners = value!.map((e) {
          //       HLBannerEntity entity = e as HLBannerEntity;
          //       return entity;
          //     }).toList();
          //   });
          //   print("net-get_banners:$banners");
          //   if (articles.isNotEmpty&&banners.isNotEmpty) {
          //     setState(() {});
          //   }
          // }
        }, errorCallBack: (code, msg) {
          // 请求失败
        });
  }

  ///取消收藏
  unCollect() {
    // HLHttpClient.getInstance().post("${Api.post_collect_inner_article}$currentPage/json", context: context,
    //     successCallBack: (data) async {
    //       List responseJson = data;
    //       if (responseJson.isNotEmpty) {
    //         await handleResponseJson(HLBannerEntity(), responseJson).then((value) {
    //           banners = value!.map((e) {
    //             HLBannerEntity entity = e as HLBannerEntity;
    //             return entity;
    //           }).toList();
    //         });
    //         print("net-get_banners:$banners");
    //         if (articles.isNotEmpty&&banners.isNotEmpty) {
    //           setState(() {});
    //         }
    //       }
    //     }, errorCallBack: (code, msg) {
    //       // 请求失败
    //     });
  }

}
