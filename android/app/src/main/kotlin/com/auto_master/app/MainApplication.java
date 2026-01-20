package com.auto_master.app;

import android.app.Application;

import com.yandex.mapkit.MapKitFactory;

public class MainApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        MapKitFactory.setLocale("RU_ru"); // Your preferred language. Not required, defaults to system language
        MapKitFactory.setApiKey("d03ca660-6bef-41ef-9f01-cceda4adf6bc"); // Your generated API key
    }
}