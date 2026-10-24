import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mobile/main.dart';

void main() {
  testWidgets('shows the welcome page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to my page'), findsOneWidget);
    expect(find.text('My Page'), findsOneWidget);
  });
}
