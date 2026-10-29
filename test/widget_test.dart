import 'package:flutter/material.dart';
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
    expect(find.text("You're all set!"), findsOneWidget);
  });
}
