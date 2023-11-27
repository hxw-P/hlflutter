import 'package:hlflutter/db/hl_db_base_entity.dart';

///文章model
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
  bool? fresh;
  bool? collect;
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
    this.fresh,
    this.collect,
    this.niceDate,
    this.envelopePic,
    this.superChapterName,
    this.chapterName,
  });

  // factory HLArticleEntity.fromJson(Map<String, dynamic> json) => HLArticleEntity(
  //   id: json['id'],
  //   title: json['title'],
  //   desc: json['desc'],
  //   shareUser: json['shareUser'],
  //   author: json['author'],
  //   link: json['link'],
  //   shareDate: json['shareDate'],
  //   zan: json['zan'],
  //   type: json['type'],
  //   fresh: json['fresh'],
  //   collect: json['collect'],
  //   niceDate: json['niceDate'],
  //   envelopePic: json['envelopePic'],
  //   superChapterName: json['superChapterName'],
  //   chapterName: json['chapterName'],
  // );

  @override
  HLDbBaseEntity fromMap(Map<String, dynamic> map) => HLArticleEntity(
    id: map['id'],
    title: map['title'],
    desc: map['desc'],
    shareUser: map['shareUser'],
    author: map['author'],
    link: map['link'],
    shareDate: map['shareDate'],
    zan: map['zan'],
    type: map['type'],
    fresh: map['fresh'] == "true" ? true : false,
    collect: map['collect'] == "true" ? true : false,
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
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'desc': desc,
    'shareUser': shareUser,
    'author': author,
    'link': link,
    'shareDate': shareDate,
    'zan': zan,
    'type': type,
    'fresh': fresh.toString(),
    'collect': collect.toString(),
    'niceDate': niceDate,
    'envelopePic': envelopePic,
    'superChapterName': superChapterName,
    'chapterName': chapterName,
  };
}
