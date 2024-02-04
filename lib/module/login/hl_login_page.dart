import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hlflutter/common/hl_router.dart';
import 'package:provider/provider.dart';
import '../../common/hl_app_theme.dart';
import '../../common/hl_util.dart';
import '../../custom/hl_view_tool.dart';
import '../main/hl_tabBar_page.dart';
import 'hl_login_controller.dart';
import 'hl_privacy_page.dart';

class HLLoginPage extends StatefulWidget {
  const HLLoginPage({Key? key}) : super(key: key);

  @override
  State<HLLoginPage> createState() => _HLLoginPageState();
}

class _HLLoginPageState extends State<HLLoginPage> {
  TextEditingController loginIdText  = TextEditingController();
  TextEditingController pwdText = TextEditingController();
  HLLoginController loginController = Get.put(HLLoginController());

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context);

    return Scaffold(
      appBar: HLViewTool.appBar("", appTheme, enableBack: true, bottomLineHeight: 0, backAction: () {
        loginController.backToMain();
      }),
      backgroundColor: appTheme.backGroundColor,
      body: Stack(
        children: [
          // 标题、输入框、登录按钮
          topContext(appTheme),
          // 隐私协议
          bottomPrivacy(appTheme),
        ],
      ),
    );
  }

  /// 标题、输入框、登录按钮
  topContext(AppTheme appTheme) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Util.px(35), Util.px(94), Util.px(35), 0),
      // 防止键盘弹起遮挡
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: Util.px(11.5),
              height: Util.px(16),
              child: Image.asset('images/login/login_red.png'),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Util.px(12.5), 0, 0),
              child: HLViewTool.createText(
                  text: '欢迎来到',
                  color: appTheme.subTitleDarkColor,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Util.px(10), 0, 0),
              child: HLViewTool.createText(
                  text: 'hxw的代码世界',
                  color: appTheme.titleColor,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Util.px(41), 0, 0),
              child: HLViewTool.createText(
                  text: '账号',
                  color: appTheme.titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Util.px(0), 0, 0),
              child: HLViewTool.createTextField(appTheme: appTheme, textCrl: loginIdText, placeholder: "请输入账号", textChangeBlock: (value) {
                loginIdText.text = value;
                setState(() {});
              }),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Util.px(20), 0, 0),
              child: HLViewTool.createText(
                  text: '密码',
                  color: appTheme.titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, Util.px(0), 0, 0),
              child: HLViewTool.createTextField(appTheme: appTheme, textCrl: pwdText, placeholder: "请输入密码", keyboardType: TextInputType.visiblePassword, obscure: true, textChangeBlock: (value) {
                pwdText.text = value;
                setState(() {});
              }),
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: Util.px(44),
                margin: EdgeInsets.fromLTRB(
                    Util.px(0), Util.px(53), Util.px(0), 0),
                decoration: HLViewTool.createDecoration(
                    borderColor: appTheme.borderColor,
                    width: 0,
                    contentColor: appTheme.btnBackColor,
                    radius: Util.px(22)),
                child: HLViewTool.createText(
                    text: '登录',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),
              ),
              onTap: () {
                loginController.login(context, appTheme, loginIdText.text, pwdText.text, () {
                });
              },
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    Util.px(0), Util.px(16), Util.px(0), Util.px(16)),
                child: HLViewTool.createText(
                    text: '短信验证码登录',
                    color: appTheme.subTitleDarkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
              onTap: () {
                loginController.pushWeb("短信验证码登录");
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 底部隐私协议
  bottomPrivacy(AppTheme appTheme) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(
          Util.px(0),
          MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.bottom -
              Util.px(60),
          Util.px(0),
          Util.px(0)),
      height: Util.px(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(Util.px(16), Util.px(8), Util.px(4), Util.px(8)),
                  child: SizedBox(
                    height: Util.px(12),
                    width: Util.px(12),
                    child: Obx(() => Image.asset(
                      loginController.selPrivacy.value ? "images/login/login_btn_chose_clicked.png" : "images/login/login_btn_chose_nomal.png",
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
                onTap: () {
                  // 切换隐私协议选中状态
                  loginController.changePrivacySelState();
                },
              ),
              RichText(
                text: TextSpan(
                    text: '我已阅读并同意',
                    style: TextStyle(
                      color: appTheme.subTitleDarkColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    )),
              ),
              RichText(
                text: TextSpan(
                  text: '《服务协议》',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      loginController.pushWeb("服务协议");
                    },
                  style: TextStyle(
                    color: appTheme.btnBackColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                    text: '和',
                    style: TextStyle(
                      color: appTheme.subTitleDarkColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    )),
              ),
              RichText(
                text: TextSpan(
                  text: '《隐私政策》',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      loginController.pushWeb("隐私政策");
                    },
                  style: TextStyle(
                    color: appTheme.btnBackColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                Util.px(0), Util.px(0), Util.px(0), Util.px(17)),
            child: RichText(
              text: TextSpan(
                  text: '© 2023-2030 hl.com. All rights reserved.',
                  style: TextStyle(
                    color: appTheme.subTitleDarkColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  )),
            ),
          ),
        ],
      ),
    );
  }

}
