abstract class HLDbBaseEntity {
  /// 实体转换Map
  Map<String, dynamic> toMap();

  /// map转实体
  HLDbBaseEntity fromMap(Map<String, dynamic> map);

  /// 关联表名称
  String getTableName();
}