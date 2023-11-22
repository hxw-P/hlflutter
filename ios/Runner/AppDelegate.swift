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
            guard call.method == "exchangeWithNative" else {
                result(FlutterMethodNotImplemented)
                return
            }
            guard let arguments = call.arguments as? [String: AnyObject] else {
                print("MethodChannel-没有arguments")
                return
            }
            guard let action = arguments["action"] as? String else {
                print("MethodChannel-没有action")
                return
            }
            if (action == "push") {
                // 跳转原生
                guard let router = arguments["router"] as? String else {
                    print("MethodChannel-push:没有router")
                    return
                }
                let params = arguments["params"] as? [String: String]
                self?.pushNativePage(router: router, params: params, result: result) //跳转页面
            }
            else {
                
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// push原生
    private func pushNativePage(router: String, params: [String: String]?, result: FlutterResult) {
        // 可以根据router跳转对应原生界面
        let vc: UIViewController = NativeTestCrl()
        vc.navigationItem.title = "原生页面"
        self.navigationController?.pushViewController(vc, animated: true)
        // 返回flutter和原生交互结果
        result("MethodChannel-push \(router) 成功")
    }
    
    /// 实现UINavigationControllerDelegate代理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 如果是Flutter页面，导航栏就隐藏
        navigationController.navigationBar.isHidden = viewController.isKind(of: FlutterViewController.self)
    }
    
}
