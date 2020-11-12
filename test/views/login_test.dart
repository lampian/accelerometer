import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/controllers/bindings/authBinding.dart';
import 'package:accelerometer/services/database.dart';
import 'package:accelerometer/views/login.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  BindingsBuilder binding;
  final auth = MockFirebaseAuth();
  final dataBase = MockDatabase();
  Widget makeTestableWidget({Widget child}) {
    return GetMaterialApp(
      initialBinding: binding,
      home: child,
    );
  }

  setUpAll(() async {
    binding = BindingsBuilder(() {
      Get.put<AuthController>(
        AuthController(auth: auth, dataBase: dataBase),
        permanent: false,
      );
    });
    binding.builder();
  });

  tearDown(() {
    Get.delete<AuthController>();
  });

  testWidgets('empty email and password-no sign in',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(
      child: Login(),
    ));

    final controller = Get.find<AuthController>();
    controller.emailText = '';
    controller.nameText = '';
    controller.passwordText = '';
    //when(controller.login()).thenAnswer((_) => Future.value(''));
    await tester.tap(find.byKey(Key('login')));
    //expect(didSignIn, false);
  });
}
