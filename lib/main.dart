import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hlflutter/module/common/hl_web_page.dart';
import 'package:hlflutter/module/main/hl_tabBar_page.dart';
import 'package:provider/provider.dart';
import 'package:hlflutter/common/hl_app_theme.dart';

import 'common/hl_router.dart';
import 'module/guide/hl_guide_page.dart';
import 'module/home/page/hl_article_detail_page.dart';
import 'module/home/page/hl_noti_page.dart';
import 'module/login/hl_login_page.dart';

void main() {
  final appTheme = AppTheme();
  //功能备注，在run之前，需要调用到一些原生的功能， 比如获取到软件的版本号等，就需确保在run 之前绑定到，才能调用到原生代码。
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        //注册通知
        ChangeNotifierProvider.value(value: appTheme),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      builder: (context, child) => Scaffold(
        // 全局取消键盘
        body: GestureDetector(
          onTap: () {
            hideKeyboard(context);
          },
          child: child,
        ),
      ),
      // 注册路由表 MaterialApp方式，Getx也可以生效
      home: const HLLoginPage(),
      routes: {
        HLRoutes.noti: (context) => const HLNotiPage(),
        HLRoutes.web: (context) => const HLWebPage(),
        HLRoutes.guide: (context) => const HLGuidePage(),
        HLRoutes.main: (context) => TabBarPage(),
        HLRoutes.login: (context) => const HLLoginPage(),
      },
      // 注册路由表 Getx方式
      // getPages: [
      //   GetPage(
      //     name: '/guide',
      //     page: () => const HLGuidePage(),
      //   ),
      //   GetPage(
      //     name: '/noti',
      //     page: () => const HLNotiPage(),
      //   ),
      //   GetPage(
      //     name: '/web',
      //     page: () => const HLWebPage(),
      //   ),
      // ],
    );
  }
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
