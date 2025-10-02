package com.example.get_calley_test;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
}
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.appcompat.app.AppCompatActivity;

import com.example.getcalley.R;
import com.example.getcalley.utils.PreferencesManager;

public class MainActivity extends AppCompatActivity {
    private static final int SPLASH_DELAY = 2000; // 2 seconds

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        new Handler(Looper.getMainLooper()).postDelayed(() -> {
            PreferencesManager prefsManager = PreferencesManager.getInstance(this);

            Intent intent;
            if (prefsManager.isLoggedIn()) {
                intent = new Intent(MainActivity.this, DashboardActivity.class);
            } else {
                intent = new Intent(MainActivity.this, LanguageSelectActivity.class);
            }

            startActivity(intent);
            finish();
        }, SPLASH_DELAY);
    }
}
