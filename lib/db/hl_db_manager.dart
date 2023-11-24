import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'hl_db_base_entity.dart';
import 'hl_db_config.dart';

/// 数据库存储
class HLDBManager {
  // 数据库路径
  late String databasesPath = "";

  // 数据库
  late Database database;

  // 数据库是否打开
  late bool databaseIsOpen = false;

  static HLDBManager? instance;

  static HLDBManager? getInstance() {
    instance ??= HLDBManager();
    return instance!;
  }

  /// 打开数据库
  Future<void> openDb({String? dbName}) async {
    if (databaseIsOpen) {
      // 数据库已打开
      return;
    }
    databaseIsOpen = true;
    // 获取数据库路径
    if (databasesPath.isEmpty) {
      databasesPath = await getDatabasesPath();
    }
    // 数据库名称
    if (dbName == null || dbName == "") {
      dbName = HLDBConfig.db_name;
    }
    String path = join(databasesPath, dbName + '.db');
    print('sqflite-数据库全路径:$path');
    database = await openDatabase(path, version: HLDBConfig.db_version, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE homeArticle (id INTEGER PRIMARY KEY, title TEXT, desc TEXT, shareUser TEXT, author TEXT, '
              'link TEXT, shareDate INTEGER, zan INTEGER, type INTEGER, fresh INTEGER, collect INTEGER, '
              'niceDate TEXT, envelopePic TEXT, superChapterName TEXT, chapterName TEXT)');
      await db.execute(
          'CREATE TABLE homeBanner (id INTEGER PRIMARY KEY, title TEXT, desc TEXT, imagePath TEXT,url TEXT)');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) {
      // 版本更新可能牵扯到重新插入表、删除表、表中字段变更-具体更新相关sql语句进行操作
    });
  }

  // 插入数据
  Future<void> insertItem<T extends HLDbBaseEntity>(T t) async {

    if (null == database || !database.isOpen) return;
    print(("sqflite-开始插入数据:${t.toMap()}"));

    // 插入操作
    await database.insert(
      t.getTableName(),
      t.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 删除数据
  Future<void> deleteItem<T extends HLDbBaseEntity>(T t,
      {String key = '', String value = ''}) async {
    if (null == database || !database.isOpen) return null;

    // 删除表
    if (key == '' || value == '') {
      await database.delete(t.getTableName());
    } else {
      // 删除数据
      await database.delete(
        t.getTableName(),
        where: ("$key = ?"),
        whereArgs: [value],
      );
    }
  }

  /// 更新数据
  Future<void> updateItem<T extends HLDbBaseEntity>(
      T t, String key, String value) async {
    if (null == database || !database.isOpen) return null;

    // 更新数据
    await database.update(
      t.getTableName(),
      t.toMap(),
      where: ("$key = ?"),
      whereArgs: [value],
    );
  }

  // 查询数据
  Future<List<HLDbBaseEntity>?> queryItems<T extends HLDbBaseEntity>(T t,
      {String key = '', String value = ''}) async {
    if (null == database || !database.isOpen) return null;

    List<Map<String, dynamic>> maps = [];

    // 列表数据
    if (key == '' || value == '') {
      maps = await database.query(t.getTableName());
    } else {
      maps = await database.query(
        t.getTableName(),
        where: ("$key = ?"),
        whereArgs: [value],
      );
    }

    // map转换为List集合
    return List.generate(maps.length, (i) {
      print('sqflite-查询的数据: ${maps[i]}');
      return t.fromMap(maps[i]);
    });
  }

  /// 关闭数据库
  closeDb() async {
    // 如果数据库存在，而且数据库没有关闭，先关闭数据库
    if (null != database && database.isOpen) {
      await database.close();
      // database = null;
    }
  }

  /// 删除数据库
  deleteDb(String dbName) async {
    // 如果数据库路径不存在，赋值
    if (null == databasesPath || databasesPath.isEmpty)
      databasesPath = await getDatabasesPath();

    await deleteDatabase(join(databasesPath, dbName + '.db'));
  }
}
