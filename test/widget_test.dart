import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobile/app.dart';

void main() {
  testWidgets('fades in the logo and automatically opens onboarding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Scan QR to see menu instantly'), findsNothing);

    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byType(FadeTransition), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();
    expect(find.text('Scan QR to see menu instantly'), findsOneWidget);
  });

  testWidgets('continues through all onboarding pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Image), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Scan QR to see menu instantly'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Next')))
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'Montserrat',
    );

    expect(find.text('Prev'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Prev'));
    await tester.pumpAndSettle();
    expect(find.text('Scan QR to see menu instantly'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Order & track your meal easily'), findsOneWidget);

    await tester.tap(find.text('Prev'));
    await tester.pumpAndSettle();
    expect(find.text('Scan QR to see menu instantly'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Order & track your meal easily'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Reserve your table anytime'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('E-mail address'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('E-mail address'), findsOneWidget);

    await tester.tap(find.text('Login with phone number'));
    await tester.pumpAndSettle();
    expect(find.text('Phone number'), findsOneWidget);
    await tester.tap(find.text('Login with email'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.text('Choose where you would like to receive your reset code'),
        findsOneWidget);
    await tester.tap(find.text('Phone number').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, '5551234567');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the OTP'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '123456');
    await tester.tap(find.text('Verify OTP'));
    await tester.pumpAndSettle();
    expect(find.text('Reset Password'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Create an account'), findsOneWidget);
  });
}
