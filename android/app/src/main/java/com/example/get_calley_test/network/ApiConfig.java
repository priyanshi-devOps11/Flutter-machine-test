package com.example.get_calley_test.network;

public class ApiConfig {
    // TODO: Replace with your actual API base URL
    // For testing with Postman: https://documenter.getpostman.com/view/38199901/2sB34Zpiy9
    public static final String BASE_URL = "https://your-api-base-url.com/api/";

    // API Endpoints
    public static final String REGISTER = "register";
    public static final String SEND_OTP = "send-otp";
    public static final String VERIFY_OTP = "verify-otp";
    public static final String STATS = "stats";
    public static final String USER_PROFILE = "user/profile";

    // WhatsApp Configuration
    public static final String HR_WHATSAPP_NUMBER = "918296435200";
    public static final String WHATSAPP_MESSAGE = "Hello, I would like to start calling";

    // Timeouts
    public static final int CONNECT_TIMEOUT = 30; // seconds
    public static final int READ_TIMEOUT = 30; // seconds
    public static final int WRITE_TIMEOUT = 30; // seconds
}
