package com.example.get_calley;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static final int SPLASH_DELAY = 2000; // 2 seconds

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // FlutterActivity handles everything automatically
        // The splash screen is managed by Flutter's splash.dart
    }
}