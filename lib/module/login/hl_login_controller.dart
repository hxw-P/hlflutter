import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hlflutter/common/hl_router.dart';

import '../../net/hl_api.dart';
import '../../net/hl_http_client.dart';

class HLLoginController extends GetxController {

  ///登录
  login(BuildContext context, String username, String passwod, Function complete) async{
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
    HLHttpClient.getInstance().post(Api.post_login, params: {'username': username, 'password': passwod}, context: context, successCallBack: (data) async {
      print('login success---------${data}');
      Get.toNamed(HLRoutes.main);
    });
  }

}