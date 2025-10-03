package com.example.get_calley_test.activities;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.github.mikephil.charting.charts.BarChart;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.google.android.material.navigation.NavigationView;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.YouTubePlayer;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.listeners.AbstractYouTubePlayerListener;
import com.pierfrancescosoffritti.androidyoutubeplayer.core.player.views.YouTubePlayerView;
import com.example.get_calley_test.R;
import com.example.get_calley_test.models.ApiResponse;
import com.example.get_calley_test.models.Stats;
import com.example.get_calley_test.models.User;
import com.example.get_calley_test.network.ApiConfig;
import com.example.get_calley_test.network.RetrofitClient;
import com.example.get_calley_test.utils.PreferencesManager;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DashboardActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private DrawerLayout drawerLayout;
    private TextView tvTotalCalls, tvCompletedCalls, tvPendingCalls, tvScheduledCalls;
    private TextView tvUserName, tvUserEmail;
    private BarChart barChart;
    private PieChart pieChart;
    private YouTubePlayerView youtubePlayerView;
    private SwipeRefreshLayout swipeRefreshLayout;
    private ProgressBar progressBar;
    private Button btnStartCalling;

    private Stats stats;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_dashboard);

        initViews();
        setupToolbar();
        setupDrawer();
        setupYouTubePlayer();
        loadUserData();
        loadStats();
    }

    private void initViews() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        drawerLayout = findViewById(R.id.drawer_layout);
        NavigationView navigationView = findViewById(R.id.nav_view);

        tvTotalCalls = findViewById(R.id.tvTotalCalls);
        tvCompletedCalls = findViewById(R.id.tvCompletedCalls);
        tvPendingCalls = findViewById(R.id.tvPendingCalls);
        tvScheduledCalls = findViewById(R.id.tvScheduledCalls);

        barChart = findViewById(R.id.barChart);
        pieChart = findViewById(R.id.pieChart);
        youtubePlayerView = findViewById(R.id.youtube_player_view);
        swipeRefreshLayout = findViewById(R.id.swipeRefresh);
        progressBar = findViewById(R.id.progressBar);
        btnStartCalling = findViewById(R.id.btnStartCalling);

        View headerView = navigationView.getHeaderView(0);
        tvUserName = headerView.findViewById(R.id.tvUserName);
        tvUserEmail = headerView.findViewById(R.id.tvUserEmail);

        navigationView.setNavigationItemSelectedListener(this);
        swipeRefreshLayout.setOnRefreshListener(this::loadStats);
        btnStartCalling.setOnClickListener(v -> openWhatsApp());

        setSupportActionBar(toolbar);
    }

    private void setupToolbar() {
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("Dashboard");
        }
    }

    private void setupDrawer() {
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawerLayout, findViewById(R.id.toolbar),
                R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawerLayout.addDrawerListener(toggle);
        toggle.syncState();
    }

    private void setupYouTubePlayer() {
        getLifecycle().addObserver(youtubePlayerView);

        youtubePlayerView.addYouTubePlayerListener(new AbstractYouTubePlayerListener() {
            @Override
            public void onReady(@NonNull YouTubePlayer youTubePlayer) {
                String videoId = "dQw4w9WgXcQ"; // Replace with actual video ID
                youTubePlayer.cueVideo(videoId, 0);
            }
        });
    }

    private void loadUserData() {
        User user = PreferencesManager.getInstance(this).getUser();
        if (user != null) {
            tvUserName.setText(user.getName());
            tvUserEmail.setText(user.getEmail());
        }
    }

    private void loadStats() {
        swipeRefreshLayout.setRefreshing(true);
        progressBar.setVisibility(View.VISIBLE);

        RetrofitClient.getInstance(this)
                .getApiService()
                .getStats()
                .enqueue(new Callback<ApiResponse<Stats>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<Stats>> call,
                                           Response<ApiResponse<Stats>> response) {
                        swipeRefreshLayout.setRefreshing(false);
                        progressBar.setVisibility(View.GONE);

                        if (response.isSuccessful() && response.body() != null
                                && response.body().isSuccess()) {
                            stats = response.body().getData();
                            updateUI();
                        } else {
                            // Use mock data for demonstration
                            useMockData();
                            Toast.makeText(DashboardActivity.this,
                                    "Using sample data", Toast.LENGTH_SHORT).show();
                        }
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<Stats>> call, Throwable t) {
                        swipeRefreshLayout.setRefreshing(false);
                        progressBar.setVisibility(View.GONE);
                        useMockData();
                        Toast.makeText(DashboardActivity.this,
                                "Using sample data: " + t.getMessage(),
                                Toast.LENGTH_SHORT).show();
                    }
                });
    }

    private void useMockData() {
        stats = new Stats();
        stats.setTotalCalls(150);
        stats.setCompletedCalls(100);
        stats.setPendingCalls(25);
        stats.setScheduledCalls(25);

        List<Stats.CallsByDay> callsByDay = new ArrayList<>();
        callsByDay.add(new Stats.CallsByDay("Mon", 20));
        callsByDay.add(new Stats.CallsByDay("Tue", 35));
        callsByDay.add(new Stats.CallsByDay("Wed", 28));
        callsByDay.add(new Stats.CallsByDay("Thu", 42));
        callsByDay.add(new Stats.CallsByDay("Fri", 25));
        stats.setCallsByDay(callsByDay);

        updateUI();
    }

    private void updateUI() {
        if (stats == null) return;

        tvTotalCalls.setText(String.valueOf(stats.getTotalCalls()));
        tvCompletedCalls.setText(String.valueOf(stats.getCompletedCalls()));
        tvPendingCalls.setText(String.valueOf(stats.getPendingCalls()));
        tvScheduledCalls.setText(String.valueOf(stats.getScheduledCalls()));

        setupBarChart();
        setupPieChart();
    }

    private void setupBarChart() {
        if (stats.getCallsByDay() == null || stats.getCallsByDay().isEmpty()) {
            barChart.setVisibility(View.GONE);
            return;
        }

        List<BarEntry> entries = new ArrayList<>();
        List<String> labels = new ArrayList<>();

        for (int i = 0; i < stats.getCallsByDay().size(); i++) {
            Stats.CallsByDay day = stats.getCallsByDay().get(i);
            entries.add(new BarEntry(i, day.getCalls()));
            labels.add(day.getDay());
        }

        BarDataSet dataSet = new BarDataSet(entries, "Calls This Week");
        dataSet.setColor(getResources().getColor(R.color.primary));
        dataSet.setValueTextSize(12f);

        BarData barData = new BarData(dataSet);
        barChart.setData(barData);

        XAxis xAxis = barChart.getXAxis();
        xAxis.setValueFormatter(new IndexAxisValueFormatter(labels));
        xAxis.setPosition(XAxis.XAxisPosition.BOTTOM);
        xAxis.setGranularity(1f);
        xAxis.setGranularityEnabled(true);

        barChart.getDescription().setEnabled(false);
        barChart.getLegend().setEnabled(false);
        barChart.getAxisRight().setEnabled(false);
        barChart.animateY(1000);
        barChart.invalidate();
    }

    private void setupPieChart() {
        List<PieEntry> entries = new ArrayList<>();
        entries.add(new PieEntry(stats.getCompletedCalls(), "Completed"));
        entries.add(new PieEntry(stats.getPendingCalls(), "Pending"));
        entries.add(new PieEntry(stats.getScheduledCalls(), "Scheduled"));

        PieDataSet dataSet = new PieDataSet(entries, "Call Distribution");
        dataSet.setColors(ColorTemplate.MATERIAL_COLORS);
        dataSet.setValueTextSize(14f);
        dataSet.setValueTextColor(Color.WHITE);

        PieData pieData = new PieData(dataSet);
        pieChart.setData(pieData);
        pieChart.getDescription().setEnabled(false);
        pieChart.setDrawHoleEnabled(true);
        pieChart.setHoleRadius(40f);
        pieChart.setTransparentCircleRadius(45f);
        pieChart.animateY(1000);
        pieChart.invalidate();
    }

    private void openWhatsApp() {
        try {
            String url = "https://wa.me/" + ApiConfig.HR_WHATSAPP_NUMBER +
                    "?text=" + URLEncoder.encode(ApiConfig.WHATSAPP_MESSAGE, "UTF-8");
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(url));
            startActivity(intent);
        } catch (UnsupportedEncodingException e) {
            Toast.makeText(this, "Error opening WhatsApp", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.nav_dashboard) {
            // Already on dashboard
        } else if (id == R.id.nav_profile) {
            Toast.makeText(this, "Profile", Toast.LENGTH_SHORT).show();
        } else if (id == R.id.nav_history) {
            Toast.makeText(this, "Call History", Toast.LENGTH_SHORT).show();
        } else if (id == R.id.nav_settings) {
            Toast.makeText(this, "Settings", Toast.LENGTH_SHORT).show();
        } else if (id == R.id.nav_logout) {
            logout();
        }

        drawerLayout.closeDrawer(GravityCompat.START);
        return true;
    }

    private void logout() {
        PreferencesManager.getInstance(this).logout();
        Intent intent = new Intent(this, LanguageSelectActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }

    @Override
    public void onBackPressed() {
        if (drawerLayout.isDrawerOpen(GravityCompat.START)) {
            drawerLayout.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        youtubePlayerView.release();
        super.onDestroy();
    }
}// CONTINUATION OF FLUTTER FILES