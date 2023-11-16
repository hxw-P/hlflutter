import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import '../../../common/hl_app_theme.dart';
import '../../../custom/hl_view_tool.dart';
import '../entity/hl_article_entity.dart';
import 'dart:async';

class ArticleDetailPage extends StatefulWidget {
  ArticleDetailPage({Key? key}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {

  late HLArticleEntity articleEntity;
  late WebViewController webController;

  /// 是否web正在加载，初次加载显示loading或者占位图
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    /// 获取路由参数
    articleEntity = ModalRoute
        .of(context)
        ?.settings
        .arguments as HLArticleEntity;

    /// 设置主题
    var appTheme = Provider.of<AppTheme>(context);
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            // web加载完成
            isLoading = false;
            // 刷新布局
            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(articleEntity.link == null ? 'https://flutter.dev' : articleEntity.link!));
    return Scaffold(
      backgroundColor: appTheme.backGroundColor,
      appBar: HLViewTool.appBar(
          "详情", appTheme, enableBack: true, backAction: () {
        Navigator.of(context).pop();
      }),
      body: Stack(
        children: [
          WebViewWidget(controller: webController),
          // 老版的webview
          // WebView(
          //   // 初始load的url
          //   // initialUrl: _articleEntity.link,
          //   initialUrl: "http://172.20.244.251:5500/test1.html",
          //   // JS执行模式（是否允许JS执行）
          //   javascriptMode: JavascriptMode.unrestricted,
          //   // 在WebView创建完成后调用，只会被调用一次
          //   onWebViewCreated: (WebViewController webViewController) {},
          //   // 路由委托（可以通过在此处拦截url实现JS调用Flutter部分）
          //   navigationDelegate: (NavigationRequest request) {
          //     print("美剧详情中要跳转的url ${request.url}");
          //     // 禁止路由跳转
          //     // return NavigationDecision.prevent;
          //     // 允许路由替换
          //     return NavigationDecision.navigate;
          //     // return null;
          //   },
          //   // 手势监听
          //   // gestureRecognizers: ,
          //   // WebView加载完毕时的回调。import 'dart:async'
          //   onPageFinished: (String url) {
          //     // web加载完成
          //     isLoading = false;
          //     // 刷新布局
          //     setState(() {
          //     });
          //   },
          //   // WebView加载出错
          //   onWebResourceError: (WebResourceError error) {
          //     print('错误信息：${error.description}');
          //     print('错误码：${error.errorCode}');
          //   },
          // ),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: isLoading ? Container(
                child: Align(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(
                      backgroundColor: Colors.orange),
                  alignment: Alignment(0, -0.2),
                )) : Container(),
          )
        ],
      ),
    );
  }

}
