package e.price.gs

import android.bld.PrintManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var printManager: PrintManager? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                if (call.method == "printText") {
                    val content = call.argument<String>("content")
                    if (printText(content)) {
                        result.success("Printed Successfully")
                    } else {
                        result.error("UNAVAILABLE", "Printing failed.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun printText(content: String?): Boolean {
        return try {
            if (printManager == null) {
                printManager = PrintManager.getDefaultInstance(this)
                printManager?.open()
            }
            printManager!!.addText(0, 3, false, false, content)
            printManager!!.start()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    companion object {
        private const val CHANNEL = "e.price.gs/printer"
    }
}