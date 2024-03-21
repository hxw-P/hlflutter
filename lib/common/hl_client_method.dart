import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../module/entity/hl_article_entity.dart';
import '../net/hl_api.dart';
import '../net/hl_http_client.dart';

class HLClientmethod {
  ///收藏
  static collect(HLArticleEntity articleEntity) {
    EasyLoading.show(status: '请求中...');
    if (articleEntity.collect.value == true) {
      // 取消收藏
      HLHttpClient.getInstance().post("${Api.post_uncollect_article}${articleEntity.id}/json",
          successCallBack: (data) async {
            EasyLoading.dismiss();
            articleEntity.collect.value = false;
          }, errorCallBack: (code, msg) {
            // 请求失败
            EasyLoading.dismiss();
          });
    }
    else {
      // 收藏
      HLHttpClient.getInstance().post("${Api.post_collect_article}${articleEntity.id}/json",
          successCallBack: (data) async {
            EasyLoading.dismiss();
            articleEntity.collect.value = true;
          }, errorCallBack: (code, msg) {
            // 请求失败
            EasyLoading.dismiss();
          });
    }
  }
}