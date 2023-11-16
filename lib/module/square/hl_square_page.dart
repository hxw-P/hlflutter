import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import '../../common/hl_app_theme.dart';
import '../../common/hl_util.dart';
import '../../custom/hl_view_tool.dart';

class HLSquarePage extends StatefulWidget {

  // const HLSquarePage({Key? key}) : super(key: key);

  @override
  _HLSquarePageState createState() => _HLSquarePageState();
}

class _HLSquarePageState extends State<HLSquarePage> with AutomaticKeepAliveClientMixin<HLSquarePage> {

  static const paltform = const MethodChannel("myapp.goToNativePage");
  late ScrollController _gridViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gridViewController = ScrollController()
      ..addListener(() {
        print('${_gridViewController.position}');
      });
  }

  Future<void> _goToNativePage() async {
    try {
      final int result = await paltform
          .invokeMethod('goToNativePage', {'test': 'from flutter'});
      print(result);
    } on PlatformException catch (e) {}
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: HLViewTool.appBar("广场", appTheme),
      );
  }

  Widget getPlatformTextView() {
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return AndroidView(
    //       viewType: "platform_text_view",
    //       creationParams: <String, dynamic>{"text": "Android Text View"},
    //       creationParamsCodec: const StandardMessageCodec());
    // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return UiKitView(
        viewType: "platform_text_view",
        creationParams: <String, dynamic>{"text": "iOS Label"},
        creationParamsCodec: const StandardMessageCodec());
    // } else {
    //   return Text("Not supported");
    // }
  }
}
