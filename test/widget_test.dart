import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobile/main.dart';

void main() {
  testWidgets('shows the welcome page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome Laurent'), findsOneWidget);
    expect(find.text('MY PAGE'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('Welcome Laurent')))
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'Montserrat',
    );
  });
}
