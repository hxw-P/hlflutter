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

  getCollectArticles(Function complete) {
    EasyLoading.show(status: '请求中...');
    HLHttpClient.getInstance().get("${Api.get_collect_articles}$currentPage/json",
        successCallBack: (data) async {
          EasyLoading.dismiss();
          List list = data["datas"];
          if (list.isNotEmpty) {
            List<HLArticleEntity> newList = list.map((m) {
              print("收藏的文章：${m['collect']}");
              // HLArticleEntity entity = HLArticleEntity(collect: false.obs).fromMap(m) as HLArticleEntity;
              HLArticleEntity entity = HLArticleEntity.fromJson(m);
              return entity;
            }).toList();
            if (currentPage == 0) {
              //下拉刷新
              print("---$articles");
              articles = newList;
              refreshController.refreshCompleted();
            } else {
              //上拉加载更多
              articles.addAll(newList);
              refreshController.loadComplete();
            }
            complete();
          }
          else {

          }
        }, errorCallBack: (code, msg) {
          // 请求失败
          EasyLoading.dismiss();
        });
  }

}