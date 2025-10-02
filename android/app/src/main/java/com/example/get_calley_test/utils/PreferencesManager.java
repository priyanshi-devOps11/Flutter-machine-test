package com.example.get_calley_test.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.example.get_calley_test.models.User;

public class PreferencesManager {
    private static final String PREF_NAME = "GetCalleyPrefs";
    private static final String KEY_AUTH_TOKEN = "auth_token";
    private static final String KEY_USER_DATA = "user_data";
    private static final String KEY_IS_LOGGED_IN = "is_logged_in";

    private static PreferencesManager instance;
    private final SharedPreferences preferences;
    private final Gson gson;

    private PreferencesManager(Context context) {
        preferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        gson = new Gson();
    }

    public static synchronized PreferencesManager getInstance(Context context) {
        if (instance == null) {
            instance = new PreferencesManager(context.getApplicationContext());
        }
        return instance;
    }

    public void saveAuthToken(String token) {
        preferences.edit().putString(KEY_AUTH_TOKEN, token).apply();
    }

    public String getAuthToken() {
        return preferences.getString(KEY_AUTH_TOKEN, null);
    }

    public void saveUser(User user) {
        String userJson = gson.toJson(user);
        preferences.edit()
                .putString(KEY_USER_DATA, userJson)
                .putBoolean(KEY_IS_LOGGED_IN, true)
                .apply();
    }

    public User getUser() {
        String userJson = preferences.getString(KEY_USER_DATA, null);
        if (userJson != null) {
            return gson.fromJson(userJson, User.class);
        }
        return null;
    }

    public boolean isLoggedIn() {
        return preferences.getBoolean(KEY_IS_LOGGED_IN, false);
    }

    public void logout() {
        preferences.edit().clear().apply();
    }
}