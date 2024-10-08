package e.price.gs

// import android.content.Context
// import android.print.PrintManager
// import android.print.PrintDocumentAdapter
// import android.print.PrintAttributes
// import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    //         .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
    //             if (call.method == "printText") {
    //                 val content = call.argument<String>("content")
    //                 if (content != null && printText(content)) {
    //                     result.success("Printed Successfully")
    //                 } else {
    //                     result.error("UNAVAILABLE", "Printing failed.", null)
    //                 }
    //             } else {
    //                 result.notImplemented()
    //             }
    //         }
    // }

    // private fun printText(content: String): Boolean {
    //     return try {
    //         val printManager = getSystemService(Context.PRINT_SERVICE) as PrintManager
    //         val printAdapter = TextPrintAdapter(content)

    //         val printJob = printManager.print(
    //             "PrintJob",
    //             printAdapter,
    //             PrintAttributes.Builder().build()
    //         )
    //         printJob.isCompleted
    //     } catch (e: Exception) {
    //         e.printStackTrace()
    //         false
    //     }
    // }

    // companion object {
    //     private const val CHANNEL = "e.price.gs/printer"
    // }
}
