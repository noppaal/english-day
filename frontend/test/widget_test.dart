import 'package:flutter_test/flutter_test.dart';
import 'package:english_day/main.dart';
import 'package:english_day/screens/auth/auth_screens.dart';

void main() {
  testWidgets('EnglishDayApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EnglishDayApp(
      home: SplashScreen(autoNavigate: false),
    ));
    expect(find.text('English Day'), findsWidgets);
  });
}
