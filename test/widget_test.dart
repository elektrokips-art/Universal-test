import 'package:flutter_test/flutter_test.dart';

import 'package:universal_test/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const UniversalTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Мои тесты'), findsOneWidget);
  });
}
