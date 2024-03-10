package com.example.androidjetpackflutterdemo

import android.app.Activity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.requiredSize
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidViewBinding
import com.example.androidjetpackflutterdemo.databinding.LayoutFlutterBinding
import com.example.androidjetpackflutterdemo.ui.theme.AndroidJetpackFlutterDemoTheme
import io.flutter.FlutterInjector
import io.flutter.embedding.android.ExclusiveAppComponent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformPlugin
import kotlin.random.Random

class MainActivity : ComponentActivity(), ExclusiveAppComponent<Activity>,
    MethodChannel.MethodCallHandler {
    private var spinResult: MutableState<String> = mutableStateOf("")
    private var spinEnabled: MutableState<Boolean> = mutableStateOf(true)
    private lateinit var engine: FlutterEngine
    private var platformPlugin: PlatformPlugin? = null
    private lateinit var methodChannel: MethodChannel
    private lateinit var flutterViewBinding: LayoutFlutterBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        init()

        setContent {
            AndroidJetpackFlutterDemoTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Greeting()
                }
            }
        }
    }

    @Composable
    fun Greeting() {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            SpinResultText()
            Box(
                modifier = Modifier.padding(top = 30.dp)
            )
            Text(
                text = "Result of SpinWheel",
                modifier = Modifier,
                fontSize = 30.sp
            )
            Column(
                modifier = Modifier.weight(1.0f),
                verticalArrangement = Arrangement.Center
            ){
                AndroidViewBinding(
                    LayoutFlutterBinding::inflate,
                    modifier = Modifier
                        .requiredSize(250.dp)
                ){
                    flutterView.attachToFlutterEngine(engine)
                }
            }
            SpinButton()
        }
    }

    @Composable
    fun SpinResultText(){
        val myText by spinResult

        Text(
            text = myText,
            modifier = Modifier,
            fontSize = 30.sp
        )
    }

    @Composable
    fun SpinButton(){
        val isButtonEnabled by spinEnabled

        Button(
            modifier = Modifier.fillMaxWidth(),
            onClick = {
                methodChannel.invokeMethod("Spin", Random.nextInt(8))
            },
            enabled = isButtonEnabled
        ) {
            Text(
                text = "Spin",
                fontSize = 25.sp
            )
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
        flutterViewBinding.flutterView.detachFromFlutterEngine()
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

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "SpinResult" -> {
                this.spinResult.value = call.arguments as String
            }

            "isAnimating" -> {
                this.spinEnabled.value = !(call.arguments as Boolean)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    @Preview(showBackground = true)
    @Composable
    fun GreetingPreview() {
        AndroidJetpackFlutterDemoTheme {
            Greeting()
        }
    }
}



