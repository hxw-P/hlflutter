import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hlflutter/module/project/entity/hl_project_entity.dart';
import '../common/hl_app_theme.dart';
import '../common/hl_util.dart';
import '../module/home/entity/hl_article_entity.dart';
import 'hl_view_tool.dart';

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
                    child: (article.collect != null ? article.collect! : false)
                        ? Image.asset("images/home/collect_sel.png")
                        : Image.asset("images/home/collect.png"),
                  ),
                  onTap: () {
                    print("${article.collect}点击收藏");
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
                        padding: EdgeInsets.fromLTRB(Util.px(5), 0, Util.px(10), 0),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(Util.px(5), 0, 0, 0),
                            width: Util.px(50),
                            child: FadeInImage.assetNetwork(
                                placeholder: "images/search/faild.png",
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
                          padding: EdgeInsets.fromLTRB(Util.px(5), 0, Util.px(10), 0),
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
          actionBlock();
        }
      },
    );
  }

  /// 项目列表cell
  static projectGrid(BuildContext context,
      AppTheme appTheme,
      int index,
      HLProjectEntity project, {
        Function? actionBlock,
      }) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(Util.px(5), Util.px(5), Util.px(5), Util.px(5)),
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              child: Image.network(project.envelopePic!, fit: BoxFit.fill),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HLViewTool.createText(text: "${project.title}", color: appTheme.titleColor, fontSize: 20, fontWeight: FontWeight.w400),
                HLViewTool.createText(text: "${project.desc}", color: appTheme.subTitleDarkColor, fontSize: 16, fontWeight: FontWeight.w400, maxLines: 2)
              ],
            )
          ],
        ),
        ),
      );
  }

}
