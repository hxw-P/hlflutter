import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show window;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hlflutter/custom/hxw_pop_handle.dart';
import 'package:hlflutter/module/entity/hl_user_entity.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../net/hl_cookie_handle.dart';
import 'hl_constants.dart';

///工具类
class Util {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);

  static double width = mediaQuery.size.width;

  static double height = mediaQuery.size.height;

  static double scale = mediaQuery.devicePixelRatio;

  static double textScaleFactor = mediaQuery.textScaleFactor;

  static double navigationBarHeight = mediaQuery.padding.top + kToolbarHeight;

  static double statusBarHeight = mediaQuery.padding.top;

  static double topSafeHeight = mediaQuery.padding.top;

  static double bottomSafeHeight = mediaQuery.padding.bottom;

  static double dividerHeight = px(1);

  static SharedPreferences? prefs;

  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static print(String str) {
    if (kDebugMode) {
      print(str);
    }
  }

  ///pt 转 px
  static px(double pt) {
    return pt;
  }

  ///设置适配后的宽度
  static w(double w) {
    return ScreenUtil().setWidth(w);
  }

  ///设置适配后的高度
  static h(double h) {
    return ScreenUtil().setHeight(h);
  }

  ///收起键盘
  static hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  ///颜色创建方法
  ///
  ///  * colorString  颜色值
  ///  * alpha 透明度(默认1，0-1)
  ///  * 可以输入多种格式的颜色代码，如: 0x000000,0xff000000,#000000
  static Color rgbColor(String colorString, {double alpha = 1.0}) {
    String colorStr = colorString;
    // colorString未带0xff前缀并且长度为6
    if (!colorStr.startsWith('0xff') && colorStr.length == 6) {
      colorStr = '0xff' + colorStr;
    }
    // colorString为8位，如0x000000
    if (colorStr.startsWith('0x') && colorStr.length == 8) {
      colorStr = colorStr.replaceRange(0, 2, '0xff');
    }
    // colorString为7位，如#000000
    if (colorStr.startsWith('#') && colorStr.length == 7) {
      colorStr = colorStr.replaceRange(0, 1, '0xff');
    }
    // 先分别获取色值的RGB通道
    Color color = Color(int.parse(colorStr));
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    // 通过fromRGBO返回带透明度和RGB值的颜色
    return Color.fromRGBO(red, green, blue, alpha);
  }

  ///size转单位
  static String sizeChangToUnit(double size) {
    var unitAry = ["bytes", "KB", "MB", "GB", "TB"];
    int idx = 0;
    while (size > 1024) {
      size = size / 1024;
      idx++;
      if (idx >= 4) {
        idx = 4;
      }
    }
    return formatNum(size, 2) + unitAry[idx];
  }

  static String formatNum(double num, int postion) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  ///字符串拆分高亮
  static List<TextSpan> getHighLightSpanList(
      String fileName,
      String key,
      double normalSize,
      double highLightSize,
      Color normalColor,
      Color highLightColor,
      FontWeight fontWeight) {
    List<String> fileNameSplit = [];
    List<TextSpan> spanList = [];
    if (fileName.contains(key)) {
      fileName.replaceAll(key, '!@#%^&*');
      fileNameSplit = fileName.split('!@#%^&*');
    }
    if (fileNameSplit.length > 0) {
      int num = 0;
      for (String name in fileNameSplit) {
        num++;
        spanList.add(TextSpan(
          text: name,
          style: TextStyle(
            color: normalColor,
            fontSize: normalSize,
            fontWeight: fontWeight,
            decoration: TextDecoration.none,
          ),
        ));
        if (num != fileNameSplit.length - 1) {
          spanList.add(TextSpan(
            text: key,
            style: TextStyle(
              color: highLightColor,
              fontSize: highLightSize,
              fontWeight: fontWeight,
              decoration: TextDecoration.none,
            ),
          ));
        }
      }
    }
    return spanList;
  }

  ///获取特定类型的图标
  static getCategoryIcon(int category, String ext) {
    switch (category) {
      case 0:
      //文件夹
        return 'images/search/file_type/folder.png';
        break;
      case 1:
      //视频
        return 'images/search/file_type/video.png';
        break;
      case 2:
      //音乐
        return 'images/search/file_type/music.png';
        break;
      case 3:
      //图片
        return 'images/search/file_type/picture.png';
        break;
      case 4:
      //文档
        if (ext == 'pdf') {
          return 'images/search/file_type/pdf.png';
        }
        else if (ext == 'ppt') {
          return 'images/search/file_type/ppt.png';
        }
        else if (ext == 'xls') {
          return 'images/search/file_type/excle.png';
        }
        else {
          return 'images/search/file_type/word.png';
        }
        break;
      case 5:
      //软件
        return 'images/search/file_type/un_know.png';
        break;
      case 6:
      //压缩包
        return 'images/search/file_type/zip.png';
        break;
      case 7:
      //BT
        return 'images/search/file_type/un_know.png';
        break;
    }

  }

  /// 创建SharedPreferences实例
  static Future sharedPreInstance() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  /// 是否登录
  static bool isLogin() {
    final bool isLogin = prefs!.getBool(HLConstants.isLogin) ?? false;
    return isLogin;
  }

  /// 登录
  static loginInSuccess() {
    prefs!.setBool(HLConstants.isLogin, true);
  }

  /// 登出
  static loginOutSuccess() async {
    prefs!.setBool(HLConstants.isLogin, false);
    // 清除cookie缓存
    await CookieHandle.delete();
    // 清除用户信息
    prefs!.remove(HLConstants.userInfo);
  }

  /// 是否显示引导页
  static bool isShowGuide() {
    final bool isShowGuide = prefs!.getBool(HLConstants.isShowGuide) ?? false;
    return isShowGuide;
  }

  /// 设置显示引导页
  static showGuide() {
    prefs!.setBool(HLConstants.isShowGuide, true);
  }

  /// 存储用户信息
  static setUserInfo(Map map) {
    prefs!.setString(HLConstants.userInfo, json.encode(map));
  }

  /// 获取用户信息
  static HLUserEntity getUserInfo() {
    if (prefs!.containsKey(HLConstants.userInfo)) {
      String jsonStr = prefs!.getString(HLConstants.userInfo)!;
      HLUserEntity entity =  HLUserEntity().fromMap(json.decode(jsonStr) as Map<String, dynamic>);
      return entity;
    }
    else {
      return HLUserEntity(
        userName: "",
        email: "",
      );
    }
  }

  /// 设置语言
  static setLanguage(String language) {
    prefs!.setString(HLConstants.language, language);
  }
  
  /// 获取语言
  static String getLanguage() {
    String language = prefs!.getString(HLConstants.language) ?? "";
    return language;
  }

  /// 设置深色模式
  static setDark(int mode) {
    prefs!.setInt(HLConstants.isDark, mode);
  }

  /// 获取显示模式
  static int getIsDark() {
    // 默认0，浅色模式
    int mode = prefs!.getInt(HLConstants.isDark) ?? 0;
    return mode;
  }

}
