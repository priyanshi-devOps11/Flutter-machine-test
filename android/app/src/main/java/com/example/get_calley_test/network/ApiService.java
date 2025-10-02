package com.example.get_calley_test.network;

import com.example.get_calley_test.models.ApiResponse;
import com.example.get_calley_test.models.LoginRequest;
import com.example.get_calley_test.models.LoginResponse;
import com.example.get_calley_test.models.OtpRequest;
import com.example.get_calley_test.models.RegisterRequest;
import com.example.get_calley_test.models.Stats;
import com.example.get_calley_test.models.User;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;

public interface ApiService {

    @POST(ApiConfig.REGISTER)
    Call<ApiResponse<String>> register(@Body RegisterRequest request);

    @POST(ApiConfig.SEND_OTP)
    Call<ApiResponse<String>> sendOtp(@Body OtpRequest request);

    @POST(ApiConfig.VERIFY_OTP)
    Call<ApiResponse<LoginResponse>> verifyOtp(@Body LoginRequest request);

    @GET(ApiConfig.STATS)
    Call<ApiResponse<Stats>> getStats();

    @GET(ApiConfig.USER_PROFILE)
    Call<ApiResponse<User>> getUserProfile();
}