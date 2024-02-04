import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hlflutter/common/hl_app_theme.dart';
import 'package:hlflutter/common/hl_util.dart';
import 'hxw_pop_handle.dart';
import 'dart:io';

class HLViewTool {
  ///自定义appBar
  static appBar(String title, AppTheme appTheme,
      {bool? enableBack,
        Function? backAction,
        List<Widget>? actions,
        Widget? titleView,
        double? bottomLineHeight,
        Color? backgroundColor,
        bool centerTitle = true}) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? appTheme.themeColor,
      elevation: bottomLineHeight ?? Util.px(0.5),
      //底部线条
      title: titleView ??
          Text(title,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: appTheme.titleColor,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              )),
      leading: enableBack == true
          ? GestureDetector(
        child: Container(
          color: appTheme.themeColor,
          padding: EdgeInsets.fromLTRB(Util.px(18), 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: Util.px(13),
                height: Util.px(23),
                child: Image.asset(
                  "images/search/back.png",
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (backAction != null) {
            backAction();
          }
        },
      )
          : null,
      actions: actions ?? [],
    );
  }

  ///创建导航栏按钮
  ///
  ///  * borderColor  边框颜色
  ///  * contentColor  填充色
  ///  * radius  边框弧度
  ///  * width  边框宽度
  static createAppBarAction(String image, AppTheme appTheme,
      {GlobalKey<State<StatefulWidget>>? key, Function? action}) {
    return GestureDetector(
      child: Container(
        key: key,
        color: appTheme.themeColor,
        padding: EdgeInsets.fromLTRB(Util.px(9), 0, Util.px(9), 0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: Util.px(25),
              height: Util.px(25),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (action != null) {
          action();
        }
      },
    );
  }

  ///创建普通样式列表
  ///
  ///  * borderColor  边框颜色
  ///  * contentColor  填充色
  ///  * radius  边框弧度
  ///  * width  边框宽度
  static createList(AppTheme appTheme,
      List itemList, {
        GlobalKey<State<StatefulWidget>>? key,
        double? width,
        double? height,
        double? fontSize,
        Color? textColor,
        FontWeight? fontWeight,
        double? itemHeight,
        EdgeInsetsGeometry? imagePadding,
        EdgeInsetsGeometry? textPadding,
        EdgeInsetsGeometry? dividerPadding,
        Function? actionBlock,
      }) {
    return Container(
      height: height,
      width: width,
      child: ListView.builder(
            shrinkWrap: true,//是否将列表的尺寸调整为适应内容大小
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),//禁止滚动
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("object");
                      print(index);
                      if (actionBlock != null) {
                        actionBlock(index);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: imagePadding ??
                              EdgeInsets.fromLTRB(
                                  Util.px(5), Util.px(5), 0, Util.px(5)),
                          height: itemHeight ?? 30,
                          child: Image.asset(itemList[index]["image"]),
                        ),
                        Expanded(
                          child: Container(
                            padding: textPadding ??
                                EdgeInsets.fromLTRB(Util.px(5), 0, Util.px(5), 0),
                            alignment: Alignment.centerLeft,
                            child: HLViewTool.createText(
                              text: itemList[index]["title"],
                              color: textColor ?? Colors.black,
                              fontSize: fontSize ?? 14,
                              fontWeight: fontWeight ?? FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    margin: dividerPadding ??
                        EdgeInsets.fromLTRB(Util.px(10), 0, 0, 0),
                    color: appTheme.dividerColor,
                  )
                ],
              );
            },
            itemCount: itemList.length,
          ),
    );
  }

  ///创建统一风格边框
  ///
  ///  * borderColor  边框颜色
  ///  * contentColor  填充色
  ///  * radius  边框弧度
  ///  * width  边框宽度
  static createDecoration({
    required Color borderColor,
    required Color contentColor,
    required double radius,
    double? width,
    bool enableShadow = false,
  }) {
    return BoxDecoration(
      color: contentColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border.all(
        width: width ?? Util.dividerHeight,
        color: borderColor,
      ),
      // boxShadow: enableShadow == true
      //     ? [
      //         BoxShadow(
      //           color: borderColor,
      //           offset: const Offset(1, 2), //偏移量
      //           blurRadius: 2, //阴影范围
      //           spreadRadius: 0.1, //阴影浓度
      //         )
      //       ]
      //     : [],
    );
  }

  ///创建统一风格文字
  ///
  ///  * text  文字内容
  ///  * color  颜色
  ///  * fontSize  文字大小
  ///  * fontWeight  字重
  ///  * softWrap  是否分行
  ///  * align  对齐方式
  static createText({required String text,
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    bool? softWrap,
    TextAlign? align,
    int? maxLines}) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        softWrap: softWrap ?? false,
        //默认一行
        textAlign: align ?? TextAlign.left,
        //默认左对齐
        maxLines: maxLines,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: FontStyle.normal,
          decoration: TextDecoration.none,
        ));
  }

  ///输入框文字
  // static bool isShowLoadingDialog = false;

  ///创建输入框
  ///
  ///  * appTheme  主题
  ///  * textCrl  TextEditingController
  ///  * textChangeBlock 内容输入回调,带value参数
  ///  * editCompleteBlock 输入完成回调
  ///  * placeholder 提示文字，默认空
  ///  * obscure 是否密文，默认否
  ///  * keyboardType 键盘类型，默认text
  ///  * clearImage 清除图标，默认有
  ///  * hasBorder 是否有边框，默认没有
  ///  * leftImage 左侧图标，默认没有
  ///  * rightAction 右侧按钮文字，默认空
  ///  * height 输入框高度，默认40
  ///  * contentVerticalPadding 输入框内容距离输入框底部的距离，垂直方向，默认14
  ///  * cursorHeight 光标高度，默认18
  ///  * backColor 输入框整体背景色，默认白色
  ///  * autofocus 是否自动获取焦点，默认不
  ///  * focusedBorderColor 获取焦点后的边框颜色
  static createTextField({
    required AppTheme appTheme,
    required TextEditingController textCrl,
    required Function textChangeBlock,
    Function? editCompleteBlock,
    String placeholder = "",
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String clearImage = "images/common/text-field/clear.png",
    bool hasBorder = false,
    String leftImage = "",
    String rightAction = "",
    double height = 40,
    double contentVerticalPadding = 14,
    double cursorHeight = 18,
    Color backColor = Colors.white,
    bool autofocus = false,
    Colors? focusedBorderColor,
  }) {
    textCrl.value = TextEditingValue(
        text: textCrl.text,
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: textCrl.text.length,
          ),
        ));
    return Container(
        decoration: hasBorder
            ? BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: appTheme.borderColor,
            ),
          ),
        )
            : null,
        height: Util.px(height),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                //光标宽度
                cursorWidth: 1.0,
                //光标高度
                cursorHeight: 18,
                //光标颜色
                cursorColor: Util.rgbColor("#B8BECC"),
                // 是否自动获得焦点
                autofocus: autofocus,
                obscureText: obscure,
                // 获取text内容
                controller: textCrl,
                maxLines: 1,
                textAlign: TextAlign.left,
                // 输入文字样式
                style: TextStyle(
                  color: appTheme.titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  // 文本附近绘制线性装饰的类
                  decoration: TextDecoration.none,
                ),
                // 键盘类型
                keyboardType: keyboardType,
                // 输入框修饰
                decoration: InputDecoration(
                  // 输入框填充
                  filled: true,
                  fillColor: backColor,
                  // 边框
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: appTheme.borderColor, width: 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      )),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: focusedBorderColor ?? appTheme.borderColor,
                          width: 0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      )),
                  border: UnderlineInputBorder(
                    // 此处修改border样式无效，答辩啊
                      borderSide: BorderSide(
                        width: 2,
                        color: appTheme.borderColor,
                      )),
                  // placeholder
                  hintStyle: TextStyle(
                    color: appTheme.subTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    // 文本附近绘制线性装饰的类
                    decoration: TextDecoration.none,
                  ),
                  hintText: placeholder,
                  // 输入内容偏移量
                  contentPadding: EdgeInsets.symmetric(
                      vertical: Util.px(contentVerticalPadding)),
                  // 尾部图标
                  suffixIcon: textCrl.text.isNotEmpty
                      ? GestureDetector(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: Util.px(12.5),
                            horizontal: Util.px(12.5),
                          ),
                          child: Image.asset(
                            clearImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      textChangeBlock("");
                    },
                  )
                      : null,
                  prefixIcon: leftImage.isNotEmpty
                      ? Padding(
                    padding: EdgeInsets.fromLTRB(
                        Util.px(15.5), Util.px(12), 0, Util.px(12)),
                    child: Image.asset(
                      leftImage,
                      fit: BoxFit.fill,
                    ),
                  )
                      : null,
                ),
                onChanged: (value) {
                  textChangeBlock(value);
                },
                onEditingComplete: () {
                  editCompleteBlock?.call();
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rightAction.isNotEmpty
                  ? <Widget>[
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.backColor,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, Util.px(15), 0),
                    child: Center(
                      child: Text(
                        '取消',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 14,
                          color: appTheme.subTitleColor,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {},
                )
              ]
                  : [],
            ),
          ],
        ));
  }

  ///展示安卓风格 AlertDialog
  ///
  ///  * title  标题
  ///  * content  内容
  ///  * cancel  取消按钮文字
  ///  * sure  确定按钮文字
  ///  * sureBlock  确认按钮点击事件
// static showAlertDialog(
//     BuildContext context, {
//       title = '提示',
//       content,
//       cancel = '取消',
//       sure = '确定',
//       Function sureBlock,
//     }) {
//   assert(content != null, 'Dialog 内容不能为空');
//   showDialog<int>(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return new AlertDialog(
//         title: Util.createText(text: title, color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
//         content: Util.createText(text: content, color: Colors.black, fontSize: 13, fontWeight: FontWeight.normal),
//         actions: cancel != null
//             ? <Widget>[
//           new FlatButton(
//             child: new Text(cancel),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           new FlatButton(
//             child: new Text(sure),
//             onPressed: () {
//               Navigator.of(context).pop();
//               sureBlock();
//             },
//           ),
//         ]
//             : <Widget>[
//           new FlatButton(
//             child: new Text(sure),
//             onPressed: () {
//               Navigator.of(context).pop();
//               sureBlock();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

  ///展示ios风格 AlertDialog
  ///
  ///  * title  标题
  ///  * content  内容
  ///  * cancel  取消按钮文字
  ///  * sure  确定按钮文字
  ///  * sureBlock  确认按钮点击事件
// static showIOSAlertDialog(
//     BuildContext context, {
//       title = "提示",
//       content,
//       cancel,
//       sure = "确定",
//       Function sureBlock,
//     }) {
//   assert(content != null, "Dialog 内容不能为空");
//   showCupertinoDialog<int>(
//     context: context,
//     builder: (context) {
//       return CupertinoAlertDialog(
//         title: Text(title),
//         content: Text(content),
//         actions: cancel != null
//             ? <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     top: BorderSide(
//                         color: Color(0xFFD9D9D9), width: 0.5))),
//             child: CupertinoDialogAction(
//               child: Text(cancel),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     right: BorderSide(
//                         color: Color(0xFFD9D9D9), width: 0.5),
//                     top: BorderSide(
//                         color: Color(0xFFD9D9D9), width: 0.5))),
//             child: CupertinoDialogAction(
//               child: Text(sure),
//               onPressed: () {
//                 Navigator.pop(context);
//                 sureBlock();
//               },
//             ),
//           ),
//         ]
//             : <Widget>[
//           Container(
//             decoration: BoxDecoration(
//                 border: Border(
//                     right: BorderSide(
//                         color: Color(0xFFD9D9D9), width: 0.5),
//                     top: BorderSide(
//                         color: Color(0xFFD9D9D9), width: 0.5))),
//             child: CupertinoDialogAction(
//               child: Text(sure),
//               onPressed: () {
//                 Navigator.pop(context);
//                 sureBlock();
//               },
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

  ///网络等待框是否显示标识
  static bool isShowLoadingDialog = false;

  ///关闭网络等待框
  static void closeLoadingDialog(bool isExit,
      BuildContext context,) {
    if (isExit && isShowLoadingDialog) {
      isShowLoadingDialog = false;
      PopHandle.hide(context);
    }
  }

  ///展示网络等待框
  static void showLoadingDialog(bool isExit,
      BuildContext context,) {
    if (isExit && !isShowLoadingDialog) {
      isShowLoadingDialog = true;
      PopHandle.pop(context,
          popWidget: WillPopScope(
            onWillPop: () async {
              //拦截到返回键，证明dialog被手动关闭
              return Future.value(true);
            },
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(
                backgroundColor: Colors.orange),
          ),
          mode: PopMode.top);
    }
  }
}
