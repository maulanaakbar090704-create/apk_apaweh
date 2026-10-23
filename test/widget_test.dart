import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_apaweh/main.dart';

void main() {
  testWidgets('KopiKita app loads correctly smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KopiKitaApp());

    // Verify that the title is rendered.
    expect(find.text('KopiKita ☕'), findsOneWidget);
  });
}
