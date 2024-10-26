package e.price.gs

import android.util.Log
import com.example.lc_print_sdk.PrintConfig
import com.example.lc_print_sdk.PrintUtil
// import lc_print_sdk.PrintConfig
// import lc_print_sdk.PrintUtil
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.Canvas
import android.graphics.Matrix
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.MultiFormatWriter
import com.google.zxing.common.BitMatrix
import com.google.zxing.qrcode.QRCodeWriter
import java.util.EnumMap
import java.util.HashMap

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example/printer"
    private var printUtil: PrintUtil? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // result.notImplemented()

        // // 创建 MethodChannel 处理 Flutter 传递的方法调用
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getPrinterVer" -> {
                    val version = getPrinterVersion()
                    if (version != null) {
                        result.success(version)
                    } else {
                        result.error("UNAVAILABLE", "Printer version not available.", null)
                    }
                }
                "startPrinting" -> {
                    val content: String? = call.argument("content")
                    val barcode: String? = call.argument("barcode")
                    val price: String? = call.argument("price")
                    if (content != null && barcode != null && price != null) {
                        startPrinting(content, barcode, price)
                        //startPrinting("Imprimiendo contenido de prueba")
                        result.success("Printing started")
                    } else {
                        result.error("INVALID_ARGUMENT", "Content cannot be null", null)
                    }
                }
                // "startPrinting2" -> {
                //     val content: String? = call.argument("content")
                //     if (content != null) {
                //         startPrinting2(content)
                //         result.success("Printing started")
                //     } else {
                //         result.error("INVALID_ARGUMENT", "Content cannot be null", null)
                //     }
                // }
                else -> result.notImplemented()
            }
        }
    }

//      // 获取打印机版本
    private fun getPrinterVersion(): String? {
        if (printUtil == null) {
            printUtil = PrintUtil.getInstance(this)
        }
         Log.d("MainActivity", "PrintUtil class1: " + PrintUtil::class.java.name)
         val strVersion: String = PrintUtil.getVersion()
         Log.d("MainActivity", "PrintUtil strVersion: " + strVersion)
         return "1"
    }

//     // 打印内容 卡板标
    private fun startPrinting(content: String, barcode: String, price: String) {

        val barcodeFormat: BarcodeFormat = BarcodeFormat.CODE_128

        if (printUtil == null) {
            printUtil = PrintUtil.getInstance(this)
        }
         PrintUtil.printEnableMark(true) // 开启黑标
        PrintUtil.setFeedPaperSpace(250) // 设置走纸距离
        PrintUtil.setUnwindPaperLen(10) // 设置回纸距离
//        PrintUtil.printLine(5) //打印行数
         PrintUtil.printBarcode(
             PrintConfig.Align.ALIGN_CENTER, // 居中
             55, //一维码高度
             barcode, //一维码内容
             PrintConfig.BarCodeType.TOP_TYPE_CODE128, // 一维码类型
             PrintConfig.HRIPosition.POSITION_NONE // 一维码文本内容位置
         )
        //val barcodeBitmap = createBarcodeBitmap(content, 400, 400)
        //PrintUtil.printBitmap(PrintConfig.Align.ALIGN_CENTER, barcodeBitmap)
        PrintUtil.printText(
            PrintConfig.Align.ALIGN_CENTER, // 居中
            2, //字体大小
            false, //是否粗体
            false, // 是否下划线
            content // 文本内容
        )
                PrintUtil.printText(
            PrintConfig.Align.ALIGN_CENTER, // 居中
            4, //字体大小
            true, //是否粗体
            false, // 是否下划线
            price // 文本内容
        )
         PrintUtil.start() //开始走纸
    }

    private fun createBarcodeBitmap(content: String, width: Int, height: Int): Bitmap? {
        val hints = EnumMap<EncodeHintType, Any>(EncodeHintType::class.java)
        hints[EncodeHintType.MARGIN] = 1 // 设置白边的大小

        try {
            // 生成 BitMatrix
            val bitMatrix: BitMatrix = MultiFormatWriter().encode(content, BarcodeFormat.CODE_128, width, height, hints)

            // 创建 Bitmap
            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)

            // 绘制黑色的条形到 Bitmap 上
            for (x in 0 until width) {
                for (y in 0 until height) {
                    bitmap.setPixel(x, y, if (bitMatrix[x, y]) Color.BLACK else Color.WHITE)
                }
            }

            // 创建 Matrix 对象用于旋转
            val matrix = Matrix().apply {
                postRotate(90f) // 旋转90度
            }

            // 创建一个新的 Bitmap 来保存旋转后的结果
            val rotatedBitmap = Bitmap.createBitmap(
                bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true
            )

            // 回收旧的 Bitmap
            bitmap.recycle()

            return rotatedBitmap
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }
}
