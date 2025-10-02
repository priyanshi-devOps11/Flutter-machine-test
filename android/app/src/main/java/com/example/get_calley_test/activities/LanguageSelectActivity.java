package com.example.get_calley_test.activities;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

import com.example.get_calley_testy.R;

public class LanguageSelectActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_language_select);

        Button btnEnglish = findViewById(R.id.btnEnglish);

        btnEnglish.setOnClickListener(v -> {
            Intent intent = new Intent(LanguageSelectActivity.this, RegisterActivity.class);
            startActivity(intent);
            finish();
        });
    }
}