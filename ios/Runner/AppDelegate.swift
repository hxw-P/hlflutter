import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UINavigationControllerDelegate {
    var navigationController: UINavigationController?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        self.navigationController = UINavigationController.init(rootViewController: controller)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = self.navigationController
        self.navigationController?.delegate=self //设置代理 ，配置导航栏的显示与否
        window?.makeKeyAndVisible()
        
        let flutterChannel = FlutterMethodChannel(name: "com.hl.native",binaryMessenger: controller.binaryMessenger)
        
        /// 处理flutter和原生交互
        flutterChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            if (call.method == "push") {
                // 跳转原生
                guard let arguments = call.arguments as? [String: String] else {
                    print("MethodChannel-push:没有arguments")
                    return
                }
                guard let router = arguments["router"] else {
                    print("MethodChannel-push:没有router")
                    return
                }
                self?.pushNativePage(router: router, params: arguments, result: result) //跳转页面
            }
            else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// push原生
    private func pushNativePage(router: String, params: [String: String], result: FlutterResult) {
        // 可以根据router跳转对应原生界面
        let vc: UIViewController = NativeTestCrl()
        vc.navigationItem.title = params["msg"] ?? "原生页面"
        self.navigationController?.pushViewController(vc, animated: true)
        // 返回flutter和原生交互结果，回调结果转成json字符串，不然会报错类似type '_InternalLinkedHashMap<Object?, Object?>' is not a subtype of type 'Map<String, dynamic>'
        let resultInfo: [String: String] = ["code": "1"]
        let data = try?JSONSerialization.data(withJSONObject: resultInfo, options: [])
        let jsonString = String(data: data!, encoding: String.Encoding.utf8)
        result(jsonString)
    }
    
    /// 实现UINavigationControllerDelegate代理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 如果是Flutter页面，导航栏就隐藏
        navigationController.navigationBar.isHidden = viewController.isKind(of: FlutterViewController.self)
    }
    
}
