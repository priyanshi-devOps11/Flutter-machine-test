package com.example.get_calley_test.activities;

import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.example.get_calley_test.R;
import com.example.get_calley_test.models.ApiResponse;
import com.example.get_calley_test.models.LoginRequest;
import com.example.get_calley_test.models.LoginResponse;
import com.example.get_calley_test.models.OtpRequest;
import com.example.get_calley_test.network.RetrofitClient;
import com.example.get_calley_test.utils.PreferencesManager;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OtpVerifyActivity extends AppCompatActivity {
    private EditText etOtp;
    private Button btnVerify, btnResend;
    private TextView tvTimer, tvPhone;
    private ProgressBar progressBar;
    private CountDownTimer countDownTimer;
    private String phone;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_otp_verify);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("Verify OTP");
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        phone = getIntent().getStringExtra("phone");
        if (phone == null) {
            finish();
            return;
        }

        initViews();
        setupListeners();
        startTimer();
    }

    private void initViews() {
        etOtp = findViewById(R.id.etOtp);
        btnVerify = findViewById(R.id.btnVerify);
        btnResend = findViewById(R.id.btnResend);
        tvTimer = findViewById(R.id.tvTimer);
        tvPhone = findViewById(R.id.tvPhone);
        progressBar = findViewById(R.id.progressBar);

        tvPhone.setText(String.format("+91 %s", phone));
    }

    private void setupListeners() {
        btnVerify.setOnClickListener(v -> verifyOtp());
        btnResend.setOnClickListener(v -> resendOtp());
    }

    private void startTimer() {
        btnResend.setEnabled(false);
        btnResend.setVisibility(View.GONE);
        tvTimer.setVisibility(View.VISIBLE);

        countDownTimer = new CountDownTimer(60000, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                tvTimer.setText(String.format("Resend OTP in %d seconds",
                        millisUntilFinished / 1000));
            }

            @Override
            public void onFinish() {
                tvTimer.setVisibility(View.GONE);
                btnResend.setVisibility(View.VISIBLE);
                btnResend.setEnabled(true);
            }
        }.start();
    }

    private void verifyOtp() {
        String otp = etOtp.getText().toString().trim();

        if (TextUtils.isEmpty(otp) || otp.length() != 6) {
            etOtp.setError("Please enter a valid 6-digit OTP");
            etOtp.requestFocus();
            return;
        }

        setLoading(true);

        LoginRequest request = new LoginRequest(phone, otp);

        Retrofit// CONTINUATION OF FLUTTER FILES
    }
}