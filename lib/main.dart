import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hlflutter/device/hl_tcp_page.dart';
import 'package:hlflutter/device/hl_udp_page.dart';
// import 'package:hlflutter/device/hl_udp_page.dart';
import 'package:hlflutter/module/common/hl_web_page.dart';
import 'package:hlflutter/module/main/hl_tabBar_page.dart';
import 'package:hlflutter/module/personal/language/hl_language_page.dart';
import 'package:hlflutter/module/personal/theme/hl_theme_page.dart';
import 'package:provider/provider.dart';
import 'package:hlflutter/common/hl_app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/hl_router.dart';
import 'common/hl_util.dart';
import 'local/hl_local.dart';
import 'module/guide/hl_guide_page.dart';
import 'module/home/page/hl_article_detail_page.dart';
import 'module/home/page/hl_noti_page.dart';
import 'module/launch/hl_launch_page.dart';
import 'module/login/hl_login_page.dart';
import 'module/personal/collect/hl_collect_page.dart';
import 'module/personal/hl_personal_page.dart';
import 'module/personal/set/hl_set_page.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

Future<void> main() async {
  final appTheme = AppTheme();
  // 功能备注，在run之前，需要调用到一些原生的功能， 比如获取到软件的版本号等，就需确保在run 之前绑定到，才能调用到原生代码。
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化SharedPreferences
  await Util.sharedPreInstance();
  runApp(
    MultiProvider(
      providers: [
        //注册通知
        ChangeNotifierProvider.value(value: appTheme),
      ],
      child: const MyApp(),
    ),
  );
  //设置loading风格
  loadingConfig();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Locale? getLocale() {
    Locale? appLocale;
    String language = Util.getLanguage();
    switch (language) {
      case "zh-Hans":
        // 简体中文
        appLocale = const Locale('zh-Hans', 'CN');
        break;
      case "zh-Hant":
      // 繁体中文
        appLocale = const Locale('zh-Hant', 'CN');
        break;
      case "en":
        // English
        appLocale = const Locale('en', 'US');
        break;
      default:
        // 默认跟随系统
        appLocale = Get.deviceLocale;
        break;
    }
    return appLocale;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 把MaterialApp换成GetMaterialApp，Getx
    return GetMaterialApp(
      title: 'Flutter Demo',
      // // 处理Named页面跳转 传递参数
      // onGenerateRoute: (RouteSettings settings) {
      //   // 统一处理
      //   final String? name = settings.name;
      //   final Function pageContentBuilder = routers[name];
      //   if (pageContentBuilder != null) {
      //     final Route route =
      //     MaterialPageRoute(
      //       builder: (context) {
      //         //将RouteSettings中的arguments参数取出来，通过构造函数传入
      //         return pageContentBuilder(context, arguments: settings.arguments);
      //       },
      //       settings: settings,
      //     );
      //     return route;
      //   }
      // },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        // 全局初始化加载框
        child = EasyLoading.init()(context, child);
        child = Scaffold(
          // 全局取消键盘
          body: GestureDetector(
            onTap: () {
              hideKeyboard(context);
            },
            child: child,
          ),
        );
        return child;
      },
      // 注册路由表 MaterialApp方式，Getx也可以生效
      home: const HLLaunchPage(),
      routes: {
        HLRoutes.noti: (context) => const HLNotiPage(),
        HLRoutes.web: (context) => HLWebPage(),
        HLRoutes.guide: (context) => const HLGuidePage(),
        HLRoutes.main: (context) => TabBarPage(),
        HLRoutes.login: (context) => const HLLoginPage(),
        HLRoutes.personal: (context) => const HLPersonalPage(),
        HLRoutes.set: (context) => HLSetPage(),
        HLRoutes.collect: (context) => const HLCollectPage(),
        HLRoutes.launch: (context) => const HLLaunchPage(),
        HLRoutes.language: (context) => HLLanguagePage(),
        HLRoutes.udp: (context) => HLUdpPage(),
        HLRoutes.tcp: (context) => HLTcpPage(),
        HLRoutes.theme: (context) => HLThemePage(),
      },
      // 多语言配置
      translations: Messages(),
      locale: getLocale(),
      fallbackLocale: const Locale("zh", "CN"),//默认语言
    );
  }
}

/// 全局隐藏键盘
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

/// loading全局设置
void loadingConfig() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class CustomAnimation {
}


