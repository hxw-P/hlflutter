import 'package:flutter/material.dart';

///弹出视图工具
class PopHandle {
  static late OverlayEntry _overlayEntry;
  static late Widget _popWidget;
  static late bool _isShowing;
  static late PopMode _mode;

  ///弹出传入的视图
  static pop(BuildContext context, {required Widget popWidget, PopMode? mode}) {
    _popWidget = popWidget;
    _mode = mode == null ? PopMode.center : mode;
    //获取OverlayState
    OverlayState? overlayState = Overlay.of(context);
    _isShowing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
//            padding: EdgeInsets.symmetric(horizontal: 40.0),
            //添加Opacity动画在政治
            child: AnimatedOpacity(
              //控制opacity值 范围从0.0到1.0
              opacity: _isShowing ? 1.0 : 0.0,
              //设置动画时长
              duration: _isShowing
                  ? Duration(milliseconds: 100)
                  : Duration(milliseconds: 400),
              child: _popWidget,
            ),
          ),
        ),
      );
      overlayState?.insert(_overlayEntry);
    } else {
      //重新绘制UI，类似setState
      _overlayEntry.markNeedsBuild();
    }
  }

  static hide (BuildContext context) async {
    _isShowing = false;
    _overlayEntry.markNeedsBuild();
    await Future.delayed(Duration(milliseconds: 400));
    _overlayEntry.remove();
    // _overlayEntry = null;
  }

}

///弹出模式
enum PopMode {
  top,//顶部
  center,//中间
  bottom,//底部
}

