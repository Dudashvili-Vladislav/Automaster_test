package com.auto_master.app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory;

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    // MapKitFactory.setApiKey("d03ca660-6bef-41ef-9f01-cceda4adf6bc") 
    super.configureFlutterEngine(flutterEngine);
  }
}