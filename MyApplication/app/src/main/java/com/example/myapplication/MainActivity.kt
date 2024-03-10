package com.example.myapplication

import android.app.Activity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.appcompat.app.AppCompatActivity
import com.example.myapplication.databinding.ActivityMainBinding
import io.flutter.FlutterInjector
import io.flutter.embedding.android.ExclusiveAppComponent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformPlugin
import kotlin.random.Random

class MainActivity : AppCompatActivity(), ExclusiveAppComponent<Activity>,
    MethodChannel.MethodCallHandler {
    private lateinit var binding: ActivityMainBinding
    private lateinit var engine: FlutterEngine
    private var platformPlugin: PlatformPlugin? = null
    private lateinit var methodChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        init()
        binding.rollButton.setOnClickListener {
            methodChannel.invokeMethod("Spin", Random.nextInt(8));
        }
    }

    private fun init() {
        engine = FlutterEngine(this)
        engine.dartExecutor.executeDartEntrypoint(

            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "main"
            )
        )

        engine.activityControlSurface.attachToActivity(
            this, this.lifecycle
        )

        binding.flutterView.attachToFlutterEngine(engine)

        methodChannel = MethodChannel(engine.dartExecutor, "SpinIngWheelChannel")
        methodChannel.setMethodCallHandler(this)
    }


    override fun onDestroy() {
        super.onDestroy()
        detachFlutterView()
    }

    private fun detachFlutterView() {
        engine.activityControlSurface.detachFromActivity()
        engine.lifecycleChannel.appIsDetached()
        binding.flutterView.detachFromFlutterEngine()
        platformPlugin?.destroy()
        platformPlugin = null
    }

    override fun detachFromFlutterEngine() {
        detachFlutterView()
    }

    override fun getAppComponent(): ComponentActivity {
        return this
    }

    override fun onResume() {
        super.onResume()
        engine.lifecycleChannel.appIsResumed()
    }

    override fun onPause() {
        super.onPause()
        engine.lifecycleChannel.appIsPaused()
    }


    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        engine.navigationChannel.popRoute()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "SpinResult" -> {
                binding.spinWheenResult.text = call.arguments as String
            }

            "isAnimating" -> {
                binding.rollButton.isEnabled = !(call.arguments as Boolean)
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}