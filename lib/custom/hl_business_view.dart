import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../common/hl_app_theme.dart';
import '../common/hl_util.dart';
import '../module/entity/hl_article_entity.dart';
import '../module/entity/hl_project_entity.dart';
import '../module/entity/hl_user_entity.dart';
import 'hl_view_tool.dart';

/// 文章列表操作
enum ArticleAction { detail, collect}

class HLBusinessView {
  /// 文章列表cell
  static articleRow(
    BuildContext context,
    AppTheme appTheme,
    int index,
    HLArticleEntity article, {
    Function? actionBlock,
  }) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, Util.px(10), 0, 0),
        padding: EdgeInsets.fromLTRB(Util.px(10), Util.px(10), Util.px(10), 0),
        color: Colors.white,
        // decoration: HLViewTool.createDecoration(borderColor: appTheme.borderColor, contentColor: Colors.white, radius: 6, enableShadow: true),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 来源
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Util.px(5), Util.px(5), 0, Util.px(5)),
                    child: Text(
                      "分类：${article.superChapterName}",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: appTheme.subTitleDarkColor,
                      ),
                    ),
                  ),
                ),
                // 收藏
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        Util.px(10), Util.px(5), Util.px(10), Util.px(5)),
                    height: Util.px(30),
                    child: Obx(()=> article.collect.value == true ? Image.asset("images/home/list_collect_sel.png")
                        : Image.asset("images/home/list_collect_nor.png")),
                  ),
                  onTap: () {
                    print("${article.collect}点击收藏");
                    if (actionBlock != null) {
                      actionBlock(ArticleAction.collect);
                    }
                  },
                )
              ],
            ),
            // 内容
            (article.desc != null ? article.desc! : "").isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(Util.px(5), 0, Util.px(10), 0),
                        child: Text(
                          "${article.title}",
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: appTheme.titleColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // 描述
                      article.envelopePic!.isNotEmpty ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(Util.px(5), 0, 0, 0),
                            width: Util.px(50),
                            child: FadeInImage.assetNetwork(
                                placeholder:
                                "images/common/img_placeholder.png",
                                fit: BoxFit.fitWidth,
                                image: article.envelopePic!),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Util.px(5), 0, Util.px(10), 0),
                              child: Text(
                                "${article.desc}",
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 15,
                                  color: appTheme.subTitleColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ) :
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Util.px(5), 0, Util.px(10), 0),
                              child: Text(
                                "${article.desc}",
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 15,
                                  color: appTheme.subTitleColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                :
                // 标题
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 这边要用expand包起来，不然当文字长度过长回报A RenderFlex overflowed by xx pixels on the right.这种错误
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              Util.px(5), 0, Util.px(10), 0),
                          child: Text(
                            "${article.title}",
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              color: appTheme.titleColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            // 发布时间、作者
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      Util.px(5), Util.px(15), Util.px(10), Util.px(5)),
                  child: Text(
                    article.author!.isNotEmpty
                        ? "作者:${article.author}"
                        : "分享者:${article.shareUser}",
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, Util.px(10), Util.px(10), Util.px(5)),
                  child: Text(
                    "${article.niceDate}",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        color: appTheme.subTitleDarkColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        if (actionBlock != null) {
          actionBlock(ArticleAction.detail);
        }
      },
    );
  }

  /// 项目列表cell
  static projectGrid(
    BuildContext context,
    AppTheme appTheme,
    int index,
    HLProjectEntity project, {
    Function? actionBlock,
  }) {
    return GestureDetector(
      child: Container(
        margin:
            EdgeInsets.fromLTRB(Util.px(5), Util.px(5), Util.px(5), Util.px(5)),
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            FadeInImage.assetNetwork(
                placeholder: "images/common/img_placeholder.png",
                fit: BoxFit.fill,
                image: project.envelopePic!),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HLViewTool.createText(
                    text: "${project.title}",
                    color: appTheme.titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
                HLViewTool.createText(
                    text: "${project.desc}",
                    color: appTheme.subTitleDarkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    maxLines: 2)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        if (actionBlock != null) {
          actionBlock();
        }
      },
    );
  }

  /// 通用cell
  static commonRow(
    BuildContext context,
    AppTheme appTheme,
    int index,
    String title,
    String iconPath, {
    Function? actionBlock,
    double height = 0,
        double imgRightGap = 0,
        Color color = Colors.white,
        EdgeInsetsGeometry? marign,
        bool hasArrow = true,
        double circular = 0,
        bool isTopFirst = false,
        bool isLoaclImage = true,
      }) {
    return GestureDetector(
      child: Container(
        //超出部分，可裁剪
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circular),
            color: color
          ),
        margin: marign??EdgeInsets.fromLTRB(Util.px(10), isTopFirst == true ? Util.px(10) : Util.px(5), Util.px(10), Util.px(5)),
        height: height == 0 ? Util.px(40) : height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height == 0 ? Util.px(40) - Util.px(1) : height - Util.px(1),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(iconPath.isNotEmpty ? Util.px(10) : 0, 0, 0, 0),
                          child: iconPath.isNotEmpty ? isLoaclImage ? Image.asset(iconPath, width: Util.px(20), height: Util.px(20)) : FadeInImage.assetNetwork(placeholder: "images/common/img_placeholder.png", fit: BoxFit.fitHeight, image: iconPath) : Container()
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(imgRightGap == 0 ? Util.px(10) : imgRightGap, 0, 0, 0),
                        child: HLViewTool.createText(
                            text: title,
                            color: appTheme.titleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                hasArrow == true ? Image.asset('images/common/arrow.png', width: Util.px(20), height: Util.px(20)) : Container(),
              ],
            ),
            Divider(
              height: Util.px(1),
              color: appTheme.dividerColor,
            )
          ],
        )
      ),
      onTap: () {
        if (actionBlock != null) {
          actionBlock(index);
        }
      },
    );
  }

  /// 用户头像
  static personalHeader(HLUserEntity userInfo, AppTheme appTheme) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Util.px(4)),
          color: appTheme.themeColor
      ),
      margin: EdgeInsets.fromLTRB(Util.px(10), Util.px(5), Util.px(10), Util.px(5)),
      height: Util.px(130+30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(Util.px(10), Util.px(10+30), 0, 0),
            width: 90,
            height: 90,
            //超出部分，可裁剪
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
            ),
            child: Image.asset('images/personal/head.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(Util.px(10), Util.px(10+30), 0, 0),
                  child: HLViewTool.createText(
                      text: "${userInfo.userName}",
                      color: appTheme.titleColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              Padding(padding: EdgeInsets.fromLTRB(Util.px(10), Util.px(10), 0, 0),
                child: HLViewTool.createText(
                    text: userInfo.email!.isNotEmpty ? "${userInfo.email}" : "1375166613@qq.com",
                    color: appTheme.subTitleDarkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),)
            ],
          )
        ],
      ),
    );
  }

}
