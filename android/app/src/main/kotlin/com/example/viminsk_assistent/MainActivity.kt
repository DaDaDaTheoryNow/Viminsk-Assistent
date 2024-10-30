package com.example.viminsk_assistent

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "overlay_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "startSpeechRecognition" -> {
                    // Здесь вы можете вызвать вашу функцию распознавания речи
                    // Например:
                    startSpeechRecognition()
                    result.success(null) // Возвращаем успешный результат
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startSpeechRecognition() {
        // Реализуйте логику распознавания речи здесь
    }
}