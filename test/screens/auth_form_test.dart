import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'Testing whether Registeration Page opens, when clicked on TextButton',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthForm(null, false)),
    );

    expect(find.byKey(ValueKey('email')), findsOneWidget);
    expect(find.byKey(ValueKey('Password')), findsOneWidget);

    //this will check, when tapped on 'I Already Have an account' the further columns exist or not
    await tester.tap(find.byKey(ValueKey('authSwitch')));
    await tester.pump();

    expect(find.byKey(ValueKey('email')), findsOneWidget);
    expect(find.byKey(ValueKey('Username')), findsOneWidget);
    expect(find.byKey(ValueKey('Password')), findsOneWidget);
    expect(find.byKey(ValueKey('Vehicle Type')), findsOneWidget);
    expect(find.byKey(ValueKey('Plate Number')), findsOneWidget);
    expect(find.byKey(ValueKey('Vehicle RC Number')), findsOneWidget);
    expect(find.byKey(ValueKey('Vehicle Model')), findsOneWidget);
    expect(find.byKey(ValueKey('Phone Number')), findsOneWidget);
    expect(find.byKey(ValueKey('DOB')), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(400, 1000));
    await tester.pump();
    //to check whether on tapping it goes back from registeration to login page
    await tester.tap(find.byKey(ValueKey('authSwitch')), warnIfMissed: false);
    await tester.pump();

    expect(find.byKey(ValueKey('email')), findsOneWidget);
    expect(find.byKey(ValueKey('Password')), findsOneWidget);
  });
}
