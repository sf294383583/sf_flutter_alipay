package com.sf.sf_flutter_alipay;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Build;

import com.alipay.sdk.app.PayTask;

import java.lang.ref.WeakReference;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SfFlutterAlipayPlugin */
public class SfFlutterAlipayPlugin implements MethodCallHandler {

  private Registrar mRegistrar;

  public SfFlutterAlipayPlugin(Registrar registrar){
    mRegistrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "sf_flutter_alipay");
    channel.setMethodCallHandler(new SfFlutterAlipayPlugin(registrar));
  }

  @TargetApi(Build.VERSION_CODES.CUPCAKE)
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("aliPay")) {
      String orderInfo = call.argument("orderInfo");
      if (orderInfo != null && orderInfo.length() != 0) {
        new PayAsyncTask(mRegistrar.activity(), result).execute(orderInfo);
      } else {
        result.error("error", "参数错误", null);
      }
    }else {
      result.notImplemented();
    }
  }

  @TargetApi(Build.VERSION_CODES.CUPCAKE)
  static class PayAsyncTask extends AsyncTask<String, Void, Map<String, String>> {

    WeakReference<Activity> mActivity;
    WeakReference<Result> mCallBack;

    PayAsyncTask(Activity activity, MethodChannel.Result callback) {
      mActivity = new WeakReference<>(activity);
      mCallBack = new WeakReference<>(callback);
    }

    @Override
    protected Map<String, String> doInBackground(String... orderInfo) {
      Activity activity = mActivity.get();
      MethodChannel.Result callback = mCallBack.get();//防止GC
      if (activity != null) {
        PayTask aliPay = new PayTask(activity);
        return aliPay.payV2(orderInfo[0], true);
      }
      return null;
    }

    @Override
    protected void onPostExecute(Map<String, String> result) {
      MethodChannel.Result callback = mCallBack.get();
      if (result != null) {
        callback.success(result);
      } else {
        callback.error("error", "支付失败！", null);
      }
    }
  }
}
