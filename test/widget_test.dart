import 'package:flutter_test/flutter_test.dart';

import 'package:aplacadorsample/main.dart';

void main() {
  testWidgets('app loads the main screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Home'), findsAtLeastNWidgets(1));
    expect(find.text('View Details'), findsOneWidget);
  });
}
