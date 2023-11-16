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
  Color _bottomAppbarSelColor = Color.fromRGBO(35, 135, 211, 1);

  ///BottomAppBar按钮正常文字颜色
  Color _bottomAppbarNorColor = Colors.black;

  ///边框颜色
  Color _borderColor = Util.rgbColor('#E0E1E5');

  ///普通白色内容块背景色
  Color _backColor = Util.rgbColor('#FFFFFF');

  ///灰色内容块背景色
  Color _grayBackColor = Util.rgbColor('#F2F2F2');

  ///整体内容背景色
  Color _backGroundColor = Util.rgbColor('#FFFFFF');

  ///整体灰色内容背景色
  Color _grayBackGroundColor = Util.rgbColor('#F2F2F2');

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

  get themeColor => _themeColor;

  get appbarTitleColor => _appbarTitleColor;

  get appbarBtnColor => _appbarBtnColor;

  get bottomAppbarSelColor => _bottomAppbarSelColor;

  get bottomAppbarNorColor => _bottomAppbarNorColor;

  get borderColor => _borderColor;

  get backColor => _backColor;

  get grayBackColor => _grayBackColor;

  get backGroundColor => _backGroundColor;

  get grayBackGroundColor => _grayBackGroundColor;

  get placeHolderColor => _placeHolderColor;

  get titleColor => _titleColor;

  get subTitleColor => _subTitleColor;

  get subTitleDarkColor => _subTitleDarkColor;

  get bottomDividerColor => _bottomDividerColor;

  get dividerColor => _dividerColor;

  get switchColor => _switchColor;

  get btnBackColor => _btnBackColor;

  void updateColors(bool isDark) {
    var color = isDark ? darkColor : normalColor;
    this._themeColor = color['themeColor']!;
    this._appbarTitleColor = color['appbarTitleColor']!;
    this._appbarBtnColor = color['appbarBtnColor']!;
    this._bottomAppbarSelColor = color['bottomAppbarSelColor']!;
    this._bottomAppbarNorColor = color['bottomAppbarNorColor']!;
    this._borderColor = color['borderColor']!;
    this._backColor = color['backColor']!;
    this._grayBackColor = color['grayBackColor']!;
    this._backGroundColor = color['backGroundColor']!;
    this._grayBackGroundColor = color['grayBackGroundColor']!;
    this._placeHolderColor = color['placeHolderColor']!;
    this._titleColor = color['titleColor']!;
    this._subTitleColor = color['subTitleColor']!;
    this._subTitleDarkColor = color['subTitleDarkColor']!;
    this._bottomDividerColor = color['bottomDividerColor']!;
    this._dividerColor = color['dividerColor']!;
    this._switchColor = color['switchColor']!;
    this._btnBackColor = color['btnBackColor']!;
    notifyListeners();
  }

  final Map<String, Color> normalColor = {
    'themeColor': Colors.white,
    'appbarTitleColor': Colors.black,
    'appbarBtnColor': Colors.black,
    'bottomAppbarSelColor': Color.fromRGBO(35, 135, 211, 1),
    'bottomAppbarNorColor': Colors.black,
    'borderColor': Util.rgbColor('#1F2833', alpha: 0.2),
    'backColor': Colors.white,
    'grayBackColor': Util.rgbColor('#F2F2F2'),
    'backGroundColor': Util.rgbColor('#FFFFFF'),
    'grayBackGroundColor': Util.rgbColor('#F2F2F2'),
    'placeHolderColor': Util.rgbColor('#999999'),
    'titleColor': Util.rgbColor('#2E3033'),
    'subTitleDarkColor': Util.rgbColor('#7E838E'),
    'subTitleColor': Util.rgbColor('#B8BECC'),
    'bottomDividerColor': Colors.black38,
    'dividerColor': Util.rgbColor('#F4F4F4'),
    'switchColor': Colors.green,
    'btnBackColor': Util.rgbColor('#2E6BE5'),
  };

  final Map<String, Color> darkColor = {
    'themeColor': Color(0xff191919),
    'appbarTitleColor': Color(0xff8f8f8f),
    'appbarBtnColor': Color(0xff8f8f8f),
    'bottomAppbarSelColor': Color.fromRGBO(35, 135, 211, 1),
    'bottomAppbarNorColor': Color(0xff606060),
    'borderColor': Util.rgbColor('#DDDDDD'),
    'backColor': Color(0xff191919),
    'grayBackColor': Color(0xff666666),
    'backGroundColor': Colors.black,
    'grayBackGroundColor': Colors.black,
    'placeHolderColor': Util.rgbColor('#999999'),
    'titleColor': Color(0xff8f8f8f),
    'subTitleColor': Color(0xff606060),
    'subTitleDarkColor': Colors.black38,
    'bottomDividerColor': Colors.black38,
    'dividerColor': Color(0xff666666),
    'switchColor': Colors.green,
    'btnBackColor': Util.rgbColor('#2E6BE5'),
  };
}
