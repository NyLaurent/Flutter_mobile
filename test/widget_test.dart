import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobile/main.dart';

void main() {
  testWidgets('continues through all onboarding pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Continue')))
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'Montserrat',
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Scan QR to see menu instantly'), findsOneWidget);
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
