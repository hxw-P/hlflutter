import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../net/hl_api.dart';
import '../../net/hl_http_client.dart';
import '../entity/hl_article_entity.dart';

class HLWebController extends GetxController {

  // 加载进度
  RxDouble progress = RxDouble(0);
  // 是否web正在加载，初次加载显示loading或者占位图
  RxBool isLoading = RxBool(true);

  /// 更新web进度
  updateProgress(int value) {
    progress.value = value/100;
  }

  ///收藏
  collect(HLArticleEntity articleEntity) {
    EasyLoading.show(status: '请求中...');
    HLHttpClient.getInstance().post("${Api.post_collect_article}${articleEntity.id}/json", context: context,
        successCallBack: (data) async {
          EasyLoading.dismiss();
          articleEntity.collect = true;
        }, errorCallBack: (code, msg) {
          // 请求失败
          EasyLoading.dismiss();
        });
  }

  ///取消收藏
  unCollect(HLArticleEntity articleEntity) {
    EasyLoading.show(status: '请求中...');
    HLHttpClient.getInstance().post("${Api.post_uncollect_article}${articleEntity.id}/json", context: context,
        successCallBack: (data) async {
          EasyLoading.dismiss();
          articleEntity.collect = false;
        }, errorCallBack: (code, msg) {
          // 请求失败
          EasyLoading.dismiss();
        });
  }

}
