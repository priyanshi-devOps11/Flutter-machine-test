import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_calley/app.dart';

void main() {
  testWidgets('Splash screen shows and navigates to Register',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp() as Widget);

    // Initially, we expect splash text or logo to appear
    expect(find.text('Get Calley'), findsOneWidget);

    // Let the splash screen finish (simulate a few seconds)
    await tester.pump(const Duration(seconds: 3));

    // After splash, app should navigate to Register screen
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('Register screen shows form fields', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp() as Widget);

    // Skip splash
    await tester.pump(const Duration(seconds: 3));

    // Check that Name and Email fields exist
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    // Check that "Send OTP" button exists
    expect(find.text('Send OTP'), findsOneWidget);
  });
}

class MyApp {}
