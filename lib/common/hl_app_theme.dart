import 'package:flutter/material.dart';
import 'package:hlflutter/common/hl_util.dart';

///主题颜色变化通知
class AppTheme with ChangeNotifier {
  ///主题颜色/AppBar背景色
  Color _themeColor = Colors.white;

  ///AppBar标题颜色
  Color _appbarTitleColor = Util.rgbColor('#A0A0A0');

  ///AppBar按钮颜色
  Color _appbarBtnColor = Util.rgbColor('#444444');

  ///BottomAppBar按钮选中文字颜色
  Color _bottomAppbarSelColor = const Color.fromRGBO(35, 135, 211, 1);

  ///BottomAppBar按钮正常文字颜色
  Color _bottomAppbarNorColor = Colors.black;

  ///边框颜色
  Color _borderColor = Util.rgbColor('#E0E1E5');

  ///普通白色内容块背景色
  Color _backColor = Util.rgbColor('#FFFFFF');

  ///灰色内容块背景色
  Color _grayBackColor = Util.rgbColor('#F2F2F2');

  ///整体内容背景色
  Color _backGroundColor = Util.rgbColor('#F2F2F2');

  ///占位文字颜色
  Color _placeHolderColor = Util.rgbColor('#999999');

  ///主标题颜色
  Color _titleColor = Util.rgbColor('#2E3033');

  ///副标题颜色
  Color _subTitleColor = Util.rgbColor('#B8BECC');

  ///副标题颜色 深
  Color _subTitleDarkColor = Util.rgbColor('#7E838E');

  ///底部AppBar线条颜色
  Color _bottomDividerColor = Colors.black38;

  ///分割线条颜色
  Color _dividerColor = Util.rgbColor('#F4F4F4');

  ///switch颜色
  Color _switchColor = Colors.green;

  /// 按钮背景色
  Color _btnBackColor = Util.rgbColor('#2E6BE5');

  /// toast背景色
  Color _toastBackColor = Util.rgbColor('#FF4040');

  /// toast文字颜色色
  Color _toastTitleColor = Util.rgbColor('#FFFAFA');

  get themeColor => _themeColor;

  get appbarTitleColor => _appbarTitleColor;

  get appbarBtnColor => _appbarBtnColor;

  get bottomAppbarSelColor => _bottomAppbarSelColor;

  get bottomAppbarNorColor => _bottomAppbarNorColor;

  get borderColor => _borderColor;

  get backColor => _backColor;

  get grayBackColor => _grayBackColor;

  get backGroundColor => _backGroundColor;

  get placeHolderColor => _placeHolderColor;

  get titleColor => _titleColor;

  get subTitleColor => _subTitleColor;

  get subTitleDarkColor => _subTitleDarkColor;

  get bottomDividerColor => _bottomDividerColor;

  get dividerColor => _dividerColor;

  get switchColor => _switchColor;

  get btnBackColor => _btnBackColor;

  get toastBackColor => _toastBackColor;
  get toastTitleColor => _toastTitleColor;

  void updateColors(bool isDark) {
    var color = isDark ? darkColor : normalColor;
    _themeColor = color['themeColor']!;
    _appbarTitleColor = color['appbarTitleColor']!;
    _appbarBtnColor = color['appbarBtnColor']!;
    _bottomAppbarSelColor = color['bottomAppbarSelColor']!;
    _bottomAppbarNorColor = color['bottomAppbarNorColor']!;
    _borderColor = color['borderColor']!;
    _backColor = color['backColor']!;
    _grayBackColor = color['grayBackColor']!;
    _backGroundColor = color['backGroundColor']!;
    _placeHolderColor = color['placeHolderColor']!;
    _titleColor = color['titleColor']!;
    _subTitleColor = color['subTitleColor']!;
    _subTitleDarkColor = color['subTitleDarkColor']!;
    _bottomDividerColor = color['bottomDividerColor']!;
    _dividerColor = color['dividerColor']!;
    _switchColor = color['switchColor']!;
    _btnBackColor = color['btnBackColor']!;
    _toastBackColor = color['toastBackColor']!;
    _toastTitleColor = color['toastTitleColor']!;
    notifyListeners();
  }

  final Map<String, Color> normalColor = {
    'themeColor': Colors.white,
    'appbarTitleColor': Colors.black,
    'appbarBtnColor': Colors.black,
    'bottomAppbarSelColor': const Color.fromRGBO(35, 135, 211, 1),
    'bottomAppbarNorColor': Colors.black,
    'borderColor': Util.rgbColor('#1F2833', alpha: 0.2),
    'backColor': Colors.white,
    'grayBackColor': Util.rgbColor('#F2F2F2'),
    'backGroundColor': Util.rgbColor('#F2F2F2'),
    'placeHolderColor': Util.rgbColor('#999999'),
    'titleColor': Util.rgbColor('#2E3033'),
    'subTitleDarkColor': Util.rgbColor('#7E838E'),
    'subTitleColor': Util.rgbColor('#B8BECC'),
    'bottomDividerColor': Colors.black38,
    'dividerColor': Util.rgbColor('#F4F4F4'),
    'switchColor': Colors.green,
    'btnBackColor': Util.rgbColor('#2E6BE5'),
    'toastBackColor': Util.rgbColor('#FF4040'),
    'toastTitleColor': Util.rgbColor('#FFFAFA'),
  };

  final Map<String, Color> darkColor = {
    'themeColor': Colors.white,
    'appbarTitleColor': const Color(0xff8f8f8f),
    'appbarBtnColor': const Color(0xff8f8f8f),
    'bottomAppbarSelColor': const Color.fromRGBO(35, 135, 211, 1),
    'bottomAppbarNorColor': const Color(0xff606060),
    'borderColor': Util.rgbColor('#DDDDDD'),
    'backColor': const Color(0xff191919),
    'grayBackColor': const Color(0xff666666),
    'backGroundColor': Colors.black,
    'placeHolderColor': Util.rgbColor('#999999'),
    'titleColor': const Color(0xff8f8f8f),
    'subTitleColor': const Color(0xff606060),
    'subTitleDarkColor': Colors.black38,
    'bottomDividerColor': Colors.black38,
    'dividerColor': const Color(0xff666666),
    'switchColor': Colors.green,
    'btnBackColor': Util.rgbColor('#2E6BE5'),
    'toastBackColor': Util.rgbColor('#FF4500'),
    'toastTitleColor': Util.rgbColor('#FFFAFA'),
  };
}
