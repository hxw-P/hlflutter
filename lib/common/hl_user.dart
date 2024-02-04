import 'package:shared_preferences/shared_preferences.dart';

import '../net/hl_cookie_handle.dart';
import 'hl_constants.dart';

class HLUser {
  /// 是否登录
  static Future<bool> isLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLogin = prefs.getBool(HLConstants.isLogin) ?? false;
    return isLogin;
  }

  /// 登录
  static loginIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(HLConstants.isLogin, true);
  }

  /// 登出
  static loginOut() async {
    // 清除cookie缓存
    await CookieHandle.delete();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(HLConstants.isLogin, false);
  }

  /// 是否显示引导页
  static Future<bool> isShowGuide() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isShowGuide = prefs.getBool(HLConstants.isShowGuide) ?? false;
    return isShowGuide;
  }

  /// 设置显示引导页
  static showGuide() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(HLConstants.isShowGuide, true);
  }

}
