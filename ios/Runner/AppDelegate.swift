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
        
        
        let jumpIosChannel = FlutterMethodChannel(name: "com.hl.native",binaryMessenger: controller.binaryMessenger)
        
        
        //处理-----跳转到iOS页面
        jumpIosChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard call.method == "jumpToNative" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.jumpToIosPageMethod(result: result) //跳转页面
        })
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //跳转到iOS页面
    private func jumpToIosPageMethod(result: FlutterResult) {
        
        let vc: UIViewController = NativeTestCrl()
        vc.navigationItem.title = "原生页面"
        self.navigationController?.pushViewController(vc, animated: true)
        
        result("跳转")
    }
    
    //实现UINavigationControllerDelegate代理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //如果是Flutter页面，导航栏就隐藏
        navigationController.navigationBar.isHidden = viewController.isKind(of: FlutterViewController.self)
    }
}
