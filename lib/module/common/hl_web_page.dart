
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hlflutter/common/hl_util.dart';
import 'package:hlflutter/module/common/hl_web_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../../../common/hl_app_theme.dart';
import '../../../custom/hl_view_tool.dart';
import 'dart:async';

import '../../common/hl_client_method.dart';
import '../entity/hl_article_entity.dart';

class HLWebPage extends StatefulWidget {
  late HLArticleEntity? articleEntity;

  HLWebPage({Key? key, this.articleEntity}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HLWebPageState createState() => _HLWebPageState();
}

class _HLWebPageState extends State<HLWebPage> {
  late String url = "";
  late String title = "";
  late WebViewController webController;
  HLWebController hlWebController = Get.put(HLWebController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context) != null) {
      print("ModalRoute 跳转 web");
      if (widget.articleEntity == null) {
        // ModalRoute跳转时，首页文章跳转传了模型，项目跳转传了参数 获取路由参数,MaterialPageRoute 方式跳转
        var argumentMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
        if (argumentMap != null) {
          url = argumentMap["url"] ?? "";
          title = argumentMap["title"] ?? "";
        }
      }
      else {
        // 只有首页文章支持web页面收藏功能
        url = widget.articleEntity?.link ?? "";
        title = widget.articleEntity?.title ?? "";
      }
    } else {
      print("Getx 跳转 web");
      // 获取路由参数,Getx 方式跳转，首页banner跳转传了参数
      url = Get.parameters['url'] ?? "";
      title = Get.parameters['title'] ?? "";
    }

    // 设置主题
    var appTheme = Provider.of<AppTheme>(context);
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            hlWebController.isLoading.value = true;
            hlWebController.updateProgress(progress);
          },
          onPageStarted: (String url) {
            hlWebController.isLoading.value = false;
            hlWebController.updateProgress(0);
          },
          onPageFinished: (String url) {
            // web加载完成
            hlWebController.isLoading.value = false;
            hlWebController.updateProgress(100);
          },
          onWebResourceError: (WebResourceError error) {
            hlWebController.isLoading.value = false;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url.isEmpty ? 'https://flutter.dev' : url));
    return Scaffold(
      backgroundColor: appTheme.backGroundColor,
      appBar:
          HLViewTool.appBar(title, appTheme, enableBack: true, backAction: () {
        Get.back(result: "get方式返回来自:$title");
      }, actions: widget.articleEntity != null ? [
    Obx(() => HLViewTool.createAppBarAction(widget.articleEntity?.collect.value == true ? "images/home/list_collect_sel.png" : "images/home/list_collect_nor.png", appTheme,
        action: () {
          HLClientmethod.collect(widget.articleEntity!);
        }))
              ] : []),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: Util.px(3),
              child: Obx(() => LinearProgressIndicator(
                    backgroundColor: appTheme.dividerColor,
                    // 背景颜色
                    valueColor: AlwaysStoppedAnimation(appTheme.subThemeColor),
                    // 进度动画颜色
                    value: hlWebController
                        .progress.value, // 如果进度是确定的，那么可以设置进度百分比，0-1
                  )),
            ),
          ),
          Obx(() => Positioned(
              top: hlWebController
                  .isLoading.value == false ? Util.px(0) : Util.px(3),
              left: 0,
              right: 0,
              bottom: 0,
              child: WebViewWidget(controller: webController))),
        ],
      ),
      // body: ChangeNotifierProvider(
      //   create: (context) => IndicatorShow(),
      //   child: Stack(
      //     children: [
      //       WebViewWidget(controller: webController),
      //       const Positioned(
      //         top: 0,
      //         left: 0,
      //         bottom: 0,
      //         right: 0,
      //         child: IndicatorWidget(),
      //       ),
      //       Builder(builder: (builderContext) {
      //         return GestureDetector(
      //           child: Container(
      //             width: 200,
      //             height: 200,
      //             color: Colors.lightBlue,
      //           ),
      //           onTap: () {
      //             // 这个地方如果使用context，运行时会抛出ProviderNotFoundException，因为此处我们使用的 context 来自于 MyApp，但 Provider 的 element 节点位于 MyApp 的下方，所以 Provider.of(context) 无法获取到 Provider 节点，需要使用通过嵌套 Builder 组件，使用子节点的 context 访问
      //             Provider.of<IndicatorShow>(builderContext, listen: false).setShow(false);
      //             // appTheme的privider的在顶层，所以不会有这个问题
      //             appTheme.updateColors(false);
      //           },
      //         );
      //       }),
      //     ],
      //   ),
      // )
    );
  }
}

// class IndicatorWidget extends StatelessWidget {
//   const IndicatorWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Align(
//       alignment: const Alignment(0, -0.2),
//       child: Provider.of<IndicatorShow>(context).isShow
//           ? Platform.isIOS
//               ? const CupertinoActivityIndicator()
//               : const CircularProgressIndicator(backgroundColor: Colors.orange)
//           : Container(),
//     );
//   }
// }
//
// class IndicatorShow with ChangeNotifier {
//   var isShow = true;
//
//   void setShow(bool show) {
//     isShow = show;
//     notifyListeners();
//   }
// }
