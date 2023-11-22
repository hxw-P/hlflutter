import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import '../../../common/hl_app_theme.dart';
import '../../../custom/hl_view_tool.dart';
import 'dart:async';

class HLWebPage extends StatefulWidget {
  const HLWebPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HLWebPageState createState() => _HLWebPageState();
}

class _HLWebPageState extends State<HLWebPage> {

  late String url = "";
  late String title = "";
  late WebViewController webController;

  /// 是否web正在加载，初次加载显示loading或者占位图
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    /// 获取路由参数
    var argumentMap = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map<String, String>;
    url = argumentMap["url"]!;
    title = argumentMap["title"]!;

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
            // setState(() {});
            // Provider.of<IndicatorShow>(context).setShow(false);
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
      ..loadRequest(Uri.parse(url.isEmpty ? 'https://flutter.dev' : url));
    return Scaffold(
      backgroundColor: appTheme.backGroundColor,
      appBar: HLViewTool.appBar(
          title, appTheme, enableBack: true, backAction: () {
        Navigator.of(context).pop();
      }),
      body: ChangeNotifierProvider(
        create: (context) => IndicatorShow(),
        child: Stack(
          children: [
            WebViewWidget(controller: webController),
            const Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: IndicatorWidget(),
            ),
            Builder(builder: (builderContext) {
              return GestureDetector(
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.lightBlue,
                ),
                onTap: () {
                  // 这个地方如果使用context，运行时会抛出ProviderNotFoundException，因为此处我们使用的 context 来自于 MyApp，但 Provider 的 element 节点位于 MyApp 的下方，所以 Provider.of(context) 无法获取到 Provider 节点，需要使用通过嵌套 Builder 组件，使用子节点的 context 访问
                  Provider.of<IndicatorShow>(builderContext, listen: false).setShow(false);
                  // appTheme的privider的在顶层，所以不会有这个问题
                  appTheme.updateColors(true);
                },
              );
            }),

          ],
        ),
      )
    );
  }

}

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Align(
      alignment: const Alignment(0, -0.2),
      child: Provider.of<IndicatorShow>(context).isShow
          ? Platform.isIOS
          ? const CupertinoActivityIndicator()
          : const CircularProgressIndicator(
          backgroundColor: Colors.orange)
      : Container(),
    );
  }

}

class IndicatorShow with ChangeNotifier {
  
  var isShow = true;
  void setShow(bool show) {
    isShow = show;
    notifyListeners();
  }

}
