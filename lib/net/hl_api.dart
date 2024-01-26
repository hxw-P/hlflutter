///请求接口
class Api {
  static const String base_url = "https://www.wanandroid.com/";

  ///登录
  static const String post_login = "user/login";

  ///首页banner
  static const String get_banners = "banner/json";

  ///首页文章列表
  static const String get_articles = "article/list/";

  ///项目列表
  static const String get_listprojects = "article/listproject/";

  ///收藏
  static const String post_collect_article = "lg/collect/";

  /// 取消收藏
  static const String post_uncollect_article = "lg/uncollect_originId/";


}
