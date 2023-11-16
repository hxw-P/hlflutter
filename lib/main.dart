import 'package:flutter/material.dart';
import 'package:hlflutter/module/common/hl_web_page.dart';
import 'package:hlflutter/module/main/hl_tabBar_page.dart';
import 'package:provider/provider.dart';
import 'package:hlflutter/common/hl_app_theme.dart';

import 'module/guide/hl_guide_page.dart';
import 'module/home/page/hl_article_detail_page.dart';
import 'module/home/page/hl_noti_page.dart';
import 'module/login/hl_login_page.dart';

void main() {
  final appTheme = AppTheme();

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
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: const HLGuidePage(),
      // 注册路由表
      routes: {
        "noti_page": (context) => const HLNotiPage(),
        "web_page": (context) => const HLWebPage(),
      },
    );
  }
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}