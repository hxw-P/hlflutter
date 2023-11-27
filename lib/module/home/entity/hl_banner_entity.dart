import 'package:hlflutter/db/hl_db_base_entity.dart';

///轮播model
class HLBannerEntity extends HLDbBaseEntity {
  int? id;
  String? title;
  String? desc;
  String? imagePath;
  String? url;

  HLBannerEntity({
    this.id,
    this.title,
    this.desc,
    this.imagePath,
    this.url,
  });

  // factory HLBannerEntity.fromJson(Map<String, dynamic> json) => HLBannerEntity(
  //   id: json['id'],
  //   title: json['title'],
  //   desc: json['desc'],
  //   imagePath: json['imagePath'],
  //   url: json['url'],
  // );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'desc': desc,
    'imagePath': imagePath,
    'url': url,
  };

  @override
  HLDbBaseEntity fromMap(Map<String, dynamic> map) => HLBannerEntity(
    id: map['id'],
    title: map['title'],
    desc: map['desc'],
    imagePath: map['imagePath'],
    url: map['url'],
  );

  @override
  String getTableName() {
    return 'homeBanner';
  }

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'desc': desc,
    'imagePath': imagePath,
    'url': url,
  };
}
