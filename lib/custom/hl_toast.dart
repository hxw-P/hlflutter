import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///吐司
class HLToast {
  static late OverlayEntry _overlayEntry; // toast靠它加到屏幕上
  static late bool _showing = false; // toast是否正在showing
  static late DateTime _startTime; // 开启一个新toast的当前时间，用于对比是否已经展示了足够时间
  static late String _msg; // 提示内容
  static late int _showTime; // toast显示时间
  static late Color _bgColor; // 背景颜色
  static late Color _textColor; // 文本颜色
  static late double _textSize; // 文字大小
  static late ToastPosition _position; // 显示位置
  static late double _pdHorizontal; // 左右边距
  static late double _pdVertical; // 上下边距

  static init() {

  }

  static void toast(
    BuildContext context, {
    String msg = "",
    int showTime = 1500,
    Color bgColor = Colors.black,
    Color textColor = Colors.white,
    double textSize = 14.0,
    ToastPosition position = ToastPosition.center,
    double pdHorizontal = 10.0,
    double pdVertical = 5.0,
  }) async {
    assert(msg != null, "提示内容不能为空");
    _msg = msg;
    _startTime = DateTime.now();
    _showTime = showTime;
    _bgColor = bgColor;
    _textColor = textColor;
    _textSize = textSize;
    _position = position;
    _pdHorizontal = pdHorizontal;
    _pdVertical = pdVertical;
    //获取OverlayState
    OverlayState? overlayState = Overlay.of(context);
    _showing = true;

    print('_overlayEntry xxxxx');

    if (_overlayEntry == null) {
      print('_overlayEntry == null');
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          //top值，可以改变这个值来改变toast在屏幕中的位置
          top: _calToastPosition(context),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            //添加Opacity动画
            child: AnimatedOpacity(
              //控制opacity值 范围从0.0到1.0
              opacity: _showing ? 1.0 : 0.0,
              //设置动画时长
              duration: _showing
                  ? Duration(milliseconds: 100)
                  : Duration(milliseconds: 400),
              child: _buildToastWidget(),
            ),
          ),
        ),
      );
      overlayState!.insert(_overlayEntry);
    } else {
      print('_overlayEntry != null');
      //重新绘制UI，类似setState
      _overlayEntry.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: _showTime)); // 等待时间

    //消失
    if (DateTime.now().difference(_startTime).inMilliseconds >= _showTime) {
      _showing = false;
      _overlayEntry.markNeedsBuild();
      await Future.delayed(Duration(milliseconds: 400));
      _overlayEntry.remove();
      // _overlayEntry = null;
    }
  }

  ///toast绘制
  static _buildToastWidget() {
    return Center(
      child: Card(
        color: _bgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _pdHorizontal, vertical: _pdVertical),
          child: Text(
            _msg,
            style: TextStyle(
              fontSize: _textSize,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }

  ///计算toast位置
  static _calToastPosition(context) {
    var backResult;
    if (_position == ToastPosition.top) {
      backResult = MediaQuery.of(context).size.height * 1 / 4;
    } else if (_position == ToastPosition.center) {
      backResult = MediaQuery.of(context).size.height * 2 / 5;
    } else {
      backResult = MediaQuery.of(context).size.height * 3 / 4;
    }
    return backResult;
  }
}

///toast位置
enum ToastPosition {
  top,
  center,
  bottom,
}
