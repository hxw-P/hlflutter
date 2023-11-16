import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import '../common/hl_config.dart';
import 'hl_api.dart';
import 'hl_client_handle.dart';
import 'hl_code.dart';
import 'hl_response_entity.dart';

///请求管理类
class HLHttpClient {
  static String _baseUrl = Api.base_url;
  static HLHttpClient? instance;
  late Dio dio;
  late BaseOptions options;
  CancelToken cancelToken = CancelToken();

  static HLHttpClient getInstance() {
    if (null == instance) instance = HLHttpClient();
    return instance!;
  }

  HLHttpClient() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: _baseUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: Duration(milliseconds: 10000),
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: Duration(milliseconds: 15000),
      //Http请求头.
      headers: {"version": "1.0.0"},
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
//      contentType: ContentType.json,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    dio = Dio(options);

    //默认使用 CookieJar , 它会将cookie保存在内存中
    dio.interceptors.add(CookieManager(CookieJar()));

    //添加拦截器
    if (HLConfig.isDebug) {
      dio.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
        // 在请求被发送之前做一些事情
        // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
        print("\n================== 请求数据 ==========================");
        print("url = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
        return handler.next(options);
      }, onResponse: (Response response, ResponseInterceptorHandler handler) {
        // 在返回响应数据之前做一些预处理
        print("\n================== 响应数据 ==========================");
        print("code = ${response.statusCode}");
        print("data = ${response.data}");
        return handler.next(response);
      }, onError: (
        DioError e,
        ErrorInterceptorHandler handler,
      ) {
        print("\n================== 请求失败 ==========================");
        return handler.next(e);
      }));
    }
  }

  ///get请求
  get(url,
      {params,
      options,
      cancelToken,
      required BuildContext context,
      Function? successCallBack,
      Function? errorCallBack}) async {
    var response;
    print("get请求");
    try {
      response = await dio.get(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      formatError(e, context, errorCallBack);
    }
    if (null != response.data) {
      ResponseEntity responseEntity =
          ResponseEntity.fromJson(json.decode(response.toString()));
      if (null != responseEntity) {
        switch (responseEntity.errorCode) {
          case 0:
            //成功
            successCallBack!(responseEntity.data);
            break;
          case Code.NOT_LOGIN_IN:
            //未登录
            ClientHandle.handleError(responseEntity.errorMsg, context);
            errorCallBack!(responseEntity.errorCode, responseEntity.errorMsg);
            if (null != context) {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return Scaffold(
              //         body: Container(),
              //       );
              //     },
              //   ),
              // );
            }
            break;
          default:
            ClientHandle.handleError(responseEntity.errorMsg, context);
            errorCallBack!(responseEntity.errorCode, responseEntity.errorMsg);
            break;
        }
      } else {
        errorCallBack!(Code.DECODE_ERROR, "数据解析出错");
      }
    } else {
      errorCallBack!(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
    }
  }

  ///post请求
  post(url,
      {params,
      options,
      cancelToken,
      required BuildContext context,
      Function? successCallBack,
      Function? errorCallBack}) async {
    var response;
    try {
      response = await dio.post(url,
          queryParameters: params, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      formatError(e, context, errorCallBack);
    }
    if (null != response.data) {
      ResponseEntity responseEntity =
          ResponseEntity.fromJson(json.decode(response.toString()));
      if (null != responseEntity) {
        switch (responseEntity.errorCode) {
          case 0:
            //成功
            successCallBack!(responseEntity.data);
            break;
          case Code.NOT_LOGIN_IN:
            //未登录
            ClientHandle.handleError(responseEntity.errorMsg, context);
            errorCallBack!(responseEntity.errorCode, responseEntity.errorMsg);
            if (null != context) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      body: Container(),
                    );
                  },
                ),
              );
            }
            break;
          default:
            ClientHandle.handleError(responseEntity.errorMsg, context);
            errorCallBack!(responseEntity.errorCode, responseEntity.errorMsg);
            break;
        }
      } else {
        errorCallBack!(Code.DECODE_ERROR, "数据解析出错");
      }
    } else {
      errorCallBack!(Code.NETWORK_ERROR, "网络不稳定，请稍后重试");
    }
  }

  ///下载
  downloadFile(urlPath, savePath) async {
    var response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(e, null, null);
    }
    return response.data;
  }

  ///请求error统一处理
  void formatError(DioError e, BuildContext? context, Function? errorCallBack) {
    print("\n================== 错误处理 ======================");
    String msg;
    if (e.type == DioErrorType.connectionTimeout) {
      // It occurs when url is opened timeout.
      msg = "连接超时";
      print("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      msg = "请求超时";
      print("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      msg = "响应超时";
      print("响应超时");
    } else if (e.type == DioErrorType.badResponse) {
      // When the server response, but with a incorrect status, such as 404, 503...
      msg = "出现异常";
      print("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      msg = "请求取消";
      print("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      msg = "未知错误";
      print("未知错误");
    }

    print("api == ${e.requestOptions.path}");
    print("errorMsg == ${e.message}");
    // 打印data，后面的代码不会走？
    // print("data == ${e.response.data}");
    ClientHandle.handleError(msg, context);
    if (errorCallBack != null) {
      errorCallBack(-1, msg);
    }
  }
}
