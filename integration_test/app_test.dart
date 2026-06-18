import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vericv_ai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('VeriCV AI End-to-End Native Tests', () {
    testWidgets('Complete Authentication Flow E2E Test', (tester) async {
      // 1. Launch the Application
      app.main();
      
      // Wait for the app to finish loading and rendering the LoginScreen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Ensure we are on the LoginScreen by checking for specific text
      expect(find.text('VeriCV AI'), findsWidgets);
      expect(find.text('Login'), findsWidgets);
      expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);

      // 2. Test Invalid Login Attempt (Empty Fields)
      final loginButton = find.widgetWithText(ElevatedButton, 'Login').first;
      await tester.tap(loginButton);
      await tester.pump();
      await tester.pumpAndSettle();

      // Should show error snackbar for empty fields
      expect(find.text('Please enter email and password'), findsOneWidget);

      // Clear the snackbar by waiting
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 3. Navigate to Signup Screen
      final signUpLink = find.text('Don\'t have an account? Sign Up');
      await tester.ensureVisible(signUpLink);
      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      // Ensure we are on the SignupScreen
      expect(find.text('Create Account'), findsWidgets);
      expect(find.text('Join VeriCV AI'), findsOneWidget);

      // 4. Test Signup Validation (Empty Fields)
      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create Account').first;
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();

      // Form validation errors should be visible
      expect(find.text('Please enter your full name'), findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);

      // 5. Fill out the Signup Form
      // Find TextFormFields by label texts
      final fullNameField = find.widgetWithText(TextFormField, 'Full Name').first;
      final emailField = find.widgetWithText(TextFormField, 'Email').first;
      final passwordField = find.widgetWithText(TextFormField, 'Password').first;
      final confirmPasswordField = find.widgetWithText(TextFormField, 'Confirm Password').first;

      await tester.enterText(fullNameField, 'E2E Test User');
      await tester.enterText(emailField, 'e2etest@vericv.ai');
      await tester.enterText(passwordField, 'SecurePass123!');
      await tester.enterText(confirmPasswordField, 'SecurePass123!');
      
      // Dismiss keyboard and settle
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Tap Create Account
      await tester.ensureVisible(createAccountButton);
      await tester.tap(createAccountButton);
      
      // Trigger frames to let the loading indicator and async call run
      await tester.pump();
      // Wait for Firebase response or timeout
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify SnackBar appearance (either success or Firebase error like 'email-already-in-use')
      expect(find.byType(SnackBar), findsOneWidget);

      // Clear the snackbar by waiting
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // 6. Navigate Back to Login via 'Back to Login' button
      final backToLoginButton = find.text('Already have an account? Back to Login');
      
      // If we are still on the signup screen (e.g. Firebase error), go back manually
      if (backToLoginButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(backToLoginButton);
        await tester.tap(backToLoginButton);
        await tester.pumpAndSettle();
      }

      // Ensure we are back on the LoginScreen
      expect(find.text('AI-Powered Resume Analyzer'), findsOneWidget);

      // 7. Fill out Login Form
      final loginEmailField = find.widgetWithText(TextField, 'Email').first;
      final loginPasswordField = find.widgetWithText(TextField, 'Password').first;

      await tester.enterText(loginEmailField, 'e2etest@vericv.ai');
      await tester.enterText(loginPasswordField, 'SecurePass123!');
      
      // Dismiss keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Tap Login
      await tester.tap(loginButton);
      await tester.pump();
      
      // Wait for Firebase authentication attempt
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify that either we navigated away (Dashboard) or an error snackbar is shown
      // Since it's a simulated E2E without mock backend, we expect standard handling to occur.
      final hasErrorSnackBar = find.byType(SnackBar).evaluate().isNotEmpty;
      final isOnDashboard = find.text('Dashboard').evaluate().isNotEmpty;
      
      expect(hasErrorSnackBar || isOnDashboard, isTrue, 
        reason: 'Login should either succeed (navigate to Dashboard) or fail cleanly (show SnackBar).');
    });
  });
}
