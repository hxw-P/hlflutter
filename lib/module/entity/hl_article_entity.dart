import 'package:get/get.dart';
import 'package:hlflutter/db/hl_db_base_entity.dart';

class HLArticleEntity extends HLDbBaseEntity {
  int? id;
  String? title;
  String? desc;
  String? shareUser;
  String? author;
  String? link;
  int? shareDate;
  int? zan;
  int? type;
  // 单独观察是否收藏，使用obx可以自动更新收藏按钮图标，同时传递model给web页面，在web页面操作收藏，也会自动更新首页和web页面右上角的收藏图标
  RxBool collect = false.obs;
  String? niceDate;
  String? envelopePic;
  String? superChapterName;
  String? chapterName;

  HLArticleEntity({
    this.id,
    this.title,
    this.desc,
    this.shareUser,
    this.author,
    this.link,
    this.shareDate,
    this.zan,
    this.type,
    required this.collect,
    this.niceDate,
    this.envelopePic,
    this.superChapterName,
    this.chapterName,
  });

  factory HLArticleEntity.fromJson(Map<String, dynamic> json) {
    if (json["collect"] != null) {
      return HLArticleEntity(
        id: json['id'],
        title: json['title'],
        desc: json['desc'],
        shareUser: json['shareUser'],
        author: json['author'],
        link: json['link'],
        shareDate: json['shareDate'],
        zan: json['zan'],
        type: json['type'],
        collect: json['collect'],
        niceDate: json['niceDate'],
        envelopePic: json['envelopePic'],
        superChapterName: json['superChapterName'],
        chapterName: json['chapterName'],
      );
    }
    else {
      return HLArticleEntity(
        id: json['id'],
        title: json['title'],
        desc: json['desc'],
        shareUser: json['shareUser'],
        author: json['author'],
        link: json['link'],
        shareDate: json['shareDate'],
        zan: json['zan'],
        type: json['type'],
        collect: true.obs,
        niceDate: json['niceDate'],
        envelopePic: json['envelopePic'],
        superChapterName: json['superChapterName'],
        chapterName: json['chapterName'],
      );
    }
  }

  @override
  HLDbBaseEntity fromMap(Map<String, dynamic> map) =>
      HLArticleEntity(
        id: map['id'],
        title: map['title'],
        desc: map['desc'],
        shareUser: map['shareUser'],
        author: map['author'],
        link: map['link'],
        shareDate: map['shareDate'],
        zan: map['zan'],
        type: map['type'],
        collect: (map['collect'] as bool).obs,
        niceDate: map['niceDate'],
        envelopePic: map['envelopePic'],
        superChapterName: map['superChapterName'],
        chapterName: map['chapterName'],
      );

  @override
  String getTableName() {
    return 'homeArticle';
  }

  @override
  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'title': title,
        'desc': desc,
        'shareUser': shareUser,
        'author': author,
        'link': link,
        'shareDate': shareDate,
        'zan': zan,
        'type': type,
        'collect': collect.toString(),
        'niceDate': niceDate,
        'envelopePic': envelopePic,
        'superChapterName': superChapterName,
        'chapterName': chapterName,
      };
}
