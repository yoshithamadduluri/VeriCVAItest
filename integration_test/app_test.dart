import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vericv_ai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('verify login screen and authentication flow',
        (tester) async {
      app.main();
      
      // Wait for the app to finish loading
      await tester.pumpAndSettle();

      // Find Email and Password text fields
      final emailField = find.widgetWithText(TextField, 'Email').first;
      final passwordField = find.widgetWithText(TextField, 'Password').first;
      final loginButton = find.widgetWithText(ElevatedButton, 'Login').first;

      // If widgetWithText fails because label is not considered 'text' in some versions,
      // fallback to byType:
      final emailFieldAlt = find.byType(TextField).at(0);
      final passwordFieldAlt = find.byType(TextField).at(1);
      final loginButtonAlt = find.byType(ElevatedButton).first;

      // Enter text into the email field
      await tester.enterText(emailFieldAlt, 'test@example.com');
      
      // Enter text into the password field
      await tester.enterText(passwordFieldAlt, 'password123');

      // Tap the login button
      await tester.tap(loginButtonAlt);
      
      // Trigger a frame
      await tester.pump();
      
      // Wait for the login request to finish (and possibly show error or navigate)
      await tester.pumpAndSettle();

      // For E2E tests without real backend seeded data, we might just expect 
      // either an error snackbar or a navigation. 
      // We will verify that tapping the button at least processed the form.
      // E.g., we check if a SnackBar appeared because of invalid credentials.
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
