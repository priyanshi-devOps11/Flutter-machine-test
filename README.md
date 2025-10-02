# Get Calley - Call Management Application

A comprehensive call management solution built with **Flutter** and **native Android (Java)**.

---

## 🚀 Features
- User Registration & OTP Verification  
- Dashboard with Call Statistics  
- Interactive Charts (fl_chart)  
- Embedded YouTube Training Videos  
- WhatsApp Integration  
- Secure Token Storage  
- Drawer Navigation  

---

## 🛠 Prerequisites

### Flutter Project
- Flutter SDK **3.10.0 or higher**  
- Dart SDK **3.0.0 or higher**  
- Android Studio / VS Code  
- Android SDK (API 21+)  

### Android Java Project
- Android Studio Arctic Fox or higher  
- JDK 11 or higher  
- Android SDK (API 21+)  
- Gradle 7.0+  

---

## ⚙️ Setup Instructions

### 1. Configure API Base URL

**Flutter:**  
Edit `lib/config.dart`:

static const String baseUrl = 'https://your-api-url.com/api';

Android:
Edit app/src/main/java/com/yourname/getcalley/network/ApiConfig.java:

public static final String BASE_URL = "https://your-api-url.com/api/";

2. Install Dependencies

Flutter:

cd flutter_project
flutter pub get


Android:

cd android_project
./gradlew build

3. API Documentation

Refer to the Postman documentation for API endpoints:
👉 API Docs

Required endpoints:

POST /register - User registration

POST /send-otp - Send OTP

POST /verify-otp - Verify OTP

GET /stats - Get call statistics

GET /user/profile - Get user profile

▶️ Running the Application
Flutter

Debug Mode:

flutter run


Build Debug APK:

flutter build apk --debug


Build Release APK:

flutter build apk --release


Build App Bundle (for Play Store):

flutter build appbundle --release

Android Java

Via Android Studio:

Open project in Android Studio

Sync Gradle

Click Run (Shift+F10)

Via Command Line:

./gradlew assembleDebug
./gradlew assembleRelease


APK Location:

Debug: app/build/outputs/apk/debug/app-debug.apk

Release: app/build/outputs/apk/release/app-release.apk

✅ Testing
Flutter Unit Tests
flutter test

Flutter Integration Tests
flutter test integration_test

Android Unit Tests
./gradlew test

Android Instrumentation Tests
./gradlew connectedAndroidTest

🎥 Screen Recording
Android Emulator
adb shell screenrecord /sdcard/demo.mp4
# Stop with Ctrl+C
adb pull /sdcard/demo.mp4

Physical Device

Use built-in screen recording or:

adb shell screenrecord --size 720x1280 /sdcard/demo.mp4

📂 Project Structure
Flutter
lib/
├── main.dart
├── app.dart
├── config.dart
├── models/
│   ├── user.dart
│   └── stats.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── splash.dart
│   ├── language_select.dart
│   ├── register.dart
│   ├── otp_verify.dart
│   └── dashboard.dart
├── services/
│   └── api_service.dart
└── widgets/
    └── app_drawer.dart

Android Java
app/src/main/
├── AndroidManifest.xml
├── java/com/yourname/getcalley/
│   ├── activities/
│   ├── models/
│   ├── network/
│   └── utils/
└── res/
    ├── layout/
    ├── values/
    └── drawable/

🔗 GitHub Repository

Flutter + Android codebase:
https://github.com/priyanshi-devOps11/Flutter-machine-test

Profile:
https://github.com/priyanshi-devOps11

🔑 GitHub Access

To grant access to info@cstech.in
:

Option 1: Make Repository Public
# Go to GitHub repo settings
Settings → Danger Zone → Change visibility → Make public

Option 2: Add as Collaborator
# Go to GitHub repo settings
Settings → Collaborators → Add people → Enter: info@cstech.in

🌱 Applying Changes to Existing Repo
# Create feature branch
git checkout -b feature/complete-implementation

# Add all files
git add .

# Commit changes
git commit -m "chore: add complete Get Calley Flutter 4 + Android(Java) implementations"

# Push to remote
git push origin feature/complete-implementation

🧩 Troubleshooting
Flutter Issues

Issue: Dependencies not resolving

flutter clean
flutter pub get

**Issue:** Build fails
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Android Issues

**Issue:** Gradle sync fails
```bash
./gradlew clean
./gradlew build --refresh-dependencies
```

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

---
