package com.example.get_calley_test.models;

public class LoginRequest {
    private String phone;
    private String otp;

    public LoginRequest(String phone, String otp) {
        this.phone = phone;
        this.otp = otp;
    }

    public String getPhone() {
        return phone;
    }

    public String getOtp() {
        return otp;
    }
}
