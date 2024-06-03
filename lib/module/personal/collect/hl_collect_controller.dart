import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hlflutter/db/hl_db_base_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../net/hl_api.dart';
import '../../../net/hl_http_client.dart';
import '../../entity/hl_article_entity.dart';

class HLCollectController extends GetxController {

  int currentPage = 0;
  List<HLArticleEntity> articles = [];
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);

  /// 生命周期
  @override
  void onInit() {
    super.onInit();
    print('Controller has been initialized.');
  }

  @override
  void onReady() {
    super.onReady();
    print('Controller is ready.');
  }

  @override
  void onClose() {
    super.onClose();
    print('Controller has been disposed.');
  }

  /// 手动移除控制器
  remove() {
    print("收藏页面控制器释放");
    Get.delete<HLCollectController>();
  }

  back() {
    Get.back();
  }

  onRefresh(Function complete) {
    currentPage = 0;
    getCollectArticles(complete);
  }

  loadMore(Function complete) {
    currentPage++;
    getCollectArticles(complete);
  }

  /// 请求收藏文章
  getCollectArticles(Function complete) {
    EasyLoading.show(status: '请求中...');
    HLHttpClient.getInstance().get("${Api.get_collect_articles}$currentPage/json",
        successCallBack: (data) async {
          EasyLoading.dismiss();
          List list = data["datas"];
          int total = data["total"];
          int size = data["size"];
          print('total === $total');
          print('size === $size');
          List<HLArticleEntity> newList = list.map((m) {
            // HLArticleEntity entity = HLArticleEntity(collect: false.obs).fromMap(m) as HLArticleEntity;
            HLArticleEntity entity = HLArticleEntity.fromJson(m);
            return entity;
          }).toList();
          if (currentPage == 0) {
            //下拉刷新
            articles = newList;
            if (articles.length == total) {
              refreshController.footerMode?.value = LoadStatus.noMore;
            }
            else {
              refreshController.footerMode?.value = LoadStatus.idle;
            }
            refreshController.refreshCompleted();
          } else {
            //上拉加载更多
            articles.addAll(newList);
            if (articles.length == total) {
              refreshController.footerMode?.value = LoadStatus.noMore;
            }
            else {
              refreshController.footerMode?.value = LoadStatus.idle;
            }
          }
          complete();
        }, errorCallBack: (code, msg) {
          // 请求失败
          EasyLoading.dismiss();
        });
  }

}