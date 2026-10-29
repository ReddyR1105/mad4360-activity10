import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/validators.dart';
import 'package:signup_app/widgets/local_tips.dart';

void main() {
  test('original validators reject invalid inputs and accept valid inputs', () {
    expect(validateName('  '), isNotNull);
    expect(validateName('Rohan'), isNull);
    expect(validateEmail(''), isNotNull);
    expect(validateEmail('abc@'), isNotNull);
    expect(validateEmail('demo@example.com'), isNull);
    expect(validatePassword('12345'), isNotNull);
    expect(validatePassword('abc123'), isNull);
  });
  test(
    'offline service is deterministic and recovers from simulated failure',
    () async {
      final service = LocalTipService();
      final tip = await service.getTip();
      expect(tip.length, lessThanOrEqualTo(240));
      expect(await service.getTip(), tip);
      await expectLater(
        service.getTip(simulateFailure: true),
        throwsStateError,
      );
      expect(await service.getTip(), tip);
    },
  );
  testWidgets('empty form displays required validation messages', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SignupApp());

    await tester.tap(find.byKey(const Key('submit')));
    await tester.pump();
    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your email address'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
  });
  testWidgets('tip error and retry produce real UI states', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LocalTips())),
    );
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Preset demo tip'), findsOneWidget);
  });
  testWidgets('valid inputs show the green demo success SnackBar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SignupApp());
    await tester.enterText(find.byKey(const Key('name')), 'Rohan');
    await tester.enterText(find.byKey(const Key('email')), 'demo@example.com');
    await tester.enterText(find.byKey(const Key('password')), 'abc123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.green,
    );
  });
}
