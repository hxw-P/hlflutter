package com.example.hlflutter

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class NativeChannel(flutterEngine: BinaryMessenger, activity: FlutterActivity): MethodChannel.MethodCallHandler {
    private var channel: MethodChannel
    private var mActivity: FlutterActivity

    init {
        channel = MethodChannel(flutterEngine, "com.hl.native")
        channel.setMethodCallHandler(this)
        mActivity = activity
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        kotlin.io.println("fsdfds")
        if (call.method == "push") {
            // 跳转原生
            var intent = Intent(mActivity,NativeTestActivity::class.java)
            mActivity.startActivity(intent)
            result.success("ff")
        } else if(call.method == "别的method"){
            //处理samples.flutter.jumpto.android下别的method方法
        } else {
            result.notImplemented()
        }
    }

}