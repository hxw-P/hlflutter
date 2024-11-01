import 'package:get/get.dart';

class HLLocal {
  static const String home = 'home';//首页
  static const String project = 'project';//项目
  static const String mine = 'mine';//我的
  static const String collect = 'collect';//收藏
  static const String aboutUS = 'about_us';//关于我们
  static const String set = 'set';//设置
  static const String languageSetting = 'language_set';//多语言设置
  static const String defaultLanguage = 'default_language';//跟随系统语言
  static const String languageZHHans = 'language_zh_hans';//简体中文
  static const String languageZHHant = 'language_zh_hant';//繁体中文
  static const String languageEN = 'language_en';//英文
  static const String logout = 'logout';//退出登录
  static const String clickLogin = 'click_login';//点击登录
  static const String themeSet = 'theme_set';//主题设置
  static const String lightMode = 'light_mode';//浅色模式
  static const String darkMode = 'dark_mode';//深色模式
}

class Messages extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'zh-Hans': {
      HLLocal.home: '主页',
      HLLocal.project: '项目',
      HLLocal.mine: '我的',
      HLLocal.collect: '收藏',
      HLLocal.aboutUS: '关于我们',
      HLLocal.set: '设置',
      HLLocal.languageSetting: '多语言设置',
      HLLocal.defaultLanguage: '跟随系统语言',
      HLLocal.languageZHHans: '简体中文',
      HLLocal.languageZHHant: '繁體中文',
      HLLocal.languageEN: 'English',
      HLLocal.logout: '退出登录',
      HLLocal.clickLogin: '点击登录',
      HLLocal.themeSet: '主题设置',
      HLLocal.lightMode: '浅色模式',
      HLLocal.darkMode: '深色模式',
    },
    'zh-Hant': {
      HLLocal.home: '主頁',
      HLLocal.project: '項目',
      HLLocal.mine: '我的',
      HLLocal.collect: '收藏',
      HLLocal.aboutUS: '關於我們',
      HLLocal.set: '設定',
      HLLocal.languageSetting: '多語言設定',
      HLLocal.defaultLanguage: '跟隨系統語言',
      HLLocal.languageZHHans: '简体中文',
      HLLocal.languageZHHant: '繁體中文',
      HLLocal.languageEN: 'English',
      HLLocal.logout: '登出',
      HLLocal.clickLogin: '點擊登入',
      HLLocal.themeSet: '主題設定',
      HLLocal.lightMode: '淺色模式',
      HLLocal.darkMode: '深色模式',
    },
    'en_US': {
      HLLocal.home: 'Home',
      HLLocal.project: 'Project',
      HLLocal.mine: 'Mine',
      HLLocal.collect: 'Collect',
      HLLocal.aboutUS: 'About Us',
      HLLocal.set: 'Set up',
      HLLocal.languageSetting: 'Multilingual setup',
      HLLocal.defaultLanguage: 'Follower system Language',
      HLLocal.languageZHHans: '简体中文',
      HLLocal.languageZHHant: '繁體中文',
      HLLocal.languageEN: 'English',
      HLLocal.logout: 'Log out',
      HLLocal.clickLogin: 'Click login',
      HLLocal.themeSet: 'Theme Settings',
      HLLocal.lightMode: 'Light color mode',
      HLLocal.darkMode: 'Dark Mode',
    },
  };
}

