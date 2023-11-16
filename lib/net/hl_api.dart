///请求接口
class Api {
  static const String base_url = "https://www.wanandroid.com/";

  ///首页banner
  static const String get_banners = "banner/json";

  ///首页文章列表
  static const String get_articles = "article/list/";

  ///收藏站内文章
  static const String post_collect_article = "lg/collect/";

  ///搜索热词
  static const String get_hot_keys = "hotkey/json";

  ///搜索
  static const String post_search_articles = "article/query/";

  ///项目分类
  static const String get_project_trees = "project/tree/json";

  ///项目对应文章列表
  static const String get_project_articles = "project/list/";

  ///公众号列表
  static const String get_official_accounts = "wxarticle/chapters/json";

  ///查看某个公众号历史数据
  static const String get_official_articles = "wxarticle/list/";

}
