import 'package:flutter_test/flutter_test.dart';
import 'package:max_tv/app/app.dart';
import 'package:max_tv/core/di/injection.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    configureDependencies();
    await tester.pumpWidget(const MaxTVApp());
    expect(find.byType(MaxTVApp), findsOneWidget);
  });
}
