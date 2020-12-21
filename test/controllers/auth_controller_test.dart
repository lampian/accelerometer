// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/services/database.dart';
//import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
//import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class WeakPasswordException extends FirebaseAuthException {
  @override
  String get code => 'weak-password';
}

class MockDatabase extends Mock implements Database {}

void main() {
  group('Validate', () {
    test('empty email', () {
      expect(Validate.email(''), false);
    });
    test('improper email', () {
      expect(Validate.email('a.com'), false);
    });
    test('proper email', () {
      expect(Validate.email('a@b.com'), true);
    });
    test('proper password', () {
      expect(Validate.password('123456'), true);
    });
    test('empty password', () {
      expect(Validate.password(''), false);
    });
    test('blank password', () {
      expect(Validate.password(' '), false);
    });
    test('proper user name', () {
      expect(Validate.userName('abcde efgh'), true);
    });
    test('empty user name', () {
      expect(Validate.userName(''), false);
    });
    test('blank user name', () {
      expect(Validate.userName(' '), false);
    });
  });
  //final firestore = MockFirestoreInstance();
  // final userCredential = MockUserCredential();
  BindingsBuilder binding;
  final auth = MockFirebaseAuth();
  final dataBase = MockDatabase();
  group('Test auth controller', () {
    setUpAll(() async {
      binding = BindingsBuilder(() {
        Get.put<AuthController>(
          AuthController(),
          permanent: false,
        );
      });
      binding.builder();
    });
    tearDown(() {
      Get.delete<AuthController>();
    });
    test('check controller initialize', () async {
      final controller = Get.find<AuthController>();
      expect(controller.initialized, true);
    });
    test('CreateUser no credentials', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '';
      controller.nameText = '';
      controller.passwordText = '';
      var result = await controller.createUser();
      expect(
          result,
          'User credentials must be properly'
          'formed and not empty');
    });
    test('CreateUser weak password', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '1@2.com';
      controller.nameText = '1 2';
      controller.passwordText = '1';
      when(auth.createUserWithEmailAndPassword(
        email: '1@2.com',
        password: '1',
      )).thenThrow(FirebaseAuthException(
        message: 'abcdef',
        code: 'weak-password',
      ));
      var result = await controller.createUser();
      expect(result, 'The password provided is too weak.');
    });
    test('CreateUser account exists', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '1@2.com';
      controller.nameText = '1 2';
      controller.passwordText = '1';
      when(auth.createUserWithEmailAndPassword(
        email: '1@2.com',
        password: '1',
      )).thenThrow(FirebaseAuthException(
        message: 'abcdef',
        code: 'email-already-in-use',
      ));
      var result = await controller.createUser();
      expect(result, 'The account already exists for that email.');
    });
    test('CreateUser unknown exception', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '1@2.com';
      controller.nameText = '1 2';
      controller.passwordText = '1';
      when(auth.createUserWithEmailAndPassword(
        email: '1@2.com',
        password: '1',
      )).thenThrow(Exception('unknown exception'));
      var result = await controller.createUser();
      expect(result, 'unknown exception');
    });
    test('CreateUser credentials ok, persist user failed', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '1@2.com';
      controller.nameText = '1 2';
      controller.passwordText = '1';
      // var _user = UserModel(
      //     id: '',
      //     name: controller.nameText,
      //     email: controller.emailText,
      //     admin: false,
      //     verified: false);
      // how to return UserCredentials from stub?
      // when(auth.createUserWithEmailAndPassword(
      //   email: controller.emailText,
      //   password: controller.passwordText,
      // )).thenAnswer((_) async => UserCredential);
      when(
        dataBase.createNewUser(any),
      ).thenAnswer(
        (_) async => false,
      );
      var result = await controller.createUser();
      expect(result, 'User registration failed - persistence');
      verify(dataBase.createNewUser(any));
    });
    test('CreateUser credentials ok, persist user true', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '1@2.com';
      controller.nameText = '1 2';
      controller.passwordText = '1';
      // var _user = UserModel(
      //     id: '',
      //     name: controller.nameText,
      //     email: controller.emailText,
      //     admin: false,
      //     verified: false);
      // how to return UserCredentials from mock?
      // when(auth.createUserWithEmailAndPassword(
      //   email: controller.emailText,
      //   password: controller.passwordText,
      // )).thenAnswer((_) async => UserCredential);
      when(
        dataBase.createNewUser(any),
      ).thenAnswer(
        (_) async => true,
      );
      var result = await controller.createUser();
      expect(result, '');
      verify(dataBase.createNewUser(any));
    });
    test('login no credentials', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '';
      controller.nameText = '';
      controller.passwordText = '';
      var result = await controller.login();
      expect(
          result,
          'User credentials must be properly '
          'formed and not empty');
    });
    test('login any user', () async {
      final controller = Get.find<AuthController>();
      controller.emailText = '1@2.com';
      controller.passwordText = '1';
      expect(controller.user, null);
      var result = await controller.login();
      expect(result, '');
      expect(controller.user.email, isNotEmpty);
    });
  });
}
