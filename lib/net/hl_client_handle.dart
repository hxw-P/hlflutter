import '../custom/hl_toast.dart';

///请求结果处理
class ClientHandle {
  ///请求错误处理
  static handleError(errorMsg, context) {
    HLToast.toast(
      context,
      msg: errorMsg,
    );
  }
}
