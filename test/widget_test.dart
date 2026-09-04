import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/app/app.dart';

void main() {
  testWidgets('OpenTrailApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OpenTrailApp(),
      ),
    );

    expect(find.text('OpenTrail Engineering Foundation Ready'), findsOneWidget);
  });
}
