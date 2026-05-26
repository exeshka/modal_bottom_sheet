import 'package:flutter_test/flutter_test.dart';
import 'package:sheet_example/main.dart';

void main() {
  testWidgets('home page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const SheetExampleApp());
    expect(find.text('CupertinoSheetRoute'), findsWidgets);
    expect(find.text('Full sheet (default)'), findsOneWidget);
  });
}
