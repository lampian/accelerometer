// @dart=2.9
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// class WeakPasswordException extends FirebaseAuthException {
//   @override
//   String get code => 'weak-password';
// }

//class MockDatabase extends Mock implements Database {}

void main() {
  BindingsBuilder binding;

  group('stateMan', () {
    setUpAll(() async {
      binding = BindingsBuilder(() {
        Get.put<HomeController>(
          HomeController(),
          permanent: false,
        );
      });
      binding.builder();
    });
    tearDown(() {
      //Get.delete<HomeController>();
    });
    group('stateMan, exit from : state=stopped', () {
      test('state=stopped mode=capture command=stop', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.stopped;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.stop,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.stopped);
        expect(controller.lastCommand, commands.stop);
      });
      test('state=stopped mode=capture command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.stopped;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.stopped);
        expect(controller.lastCommand, commands.start);
      });
      test('state=stopped mode=capture command=run', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.stopped;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.run,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.waiting);
        expect(controller.lastCommand, commands.run);
      });
    });
    group('stateMan, exit from : state=waiting', () {
      test('state=waiting mode=capture command=stop', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.waiting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.stop,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.stopped);
        expect(controller.lastCommand, commands.stop);
      });
      test('state=waiting mode=capture command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.waiting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.capturing);
        expect(controller.lastCommand, commands.start);
      });
      test('state=waiting mode=persist command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.waiting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.persist,
        );

        expect(controller.currentMode, modes.persist);
        expect(controller.currentState, states.persisting);
        expect(controller.lastCommand, commands.start);
      });
      test('state=waiting mode=capture command=run', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.waiting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.run,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.waiting);
        expect(controller.lastCommand, commands.run);
      });
    });

    group('stateMan, exit from : state=capturing', () {
      test('state=waiting mode=capture command=stop', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.capturing;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.stop,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.stopped);
        expect(controller.lastCommand, commands.stop);
      });
      test('state=waiting mode=capture command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.capturing;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.capturing);
        expect(controller.lastCommand, commands.start);
      });
      test('state=waiting mode=persist command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.capturing;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.persist,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.capturing);
        expect(controller.lastCommand, commands.start);
      });
      test('state=waiting mode=capture command=run', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.capturing;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.run,
          mode: modes.persist,
        );

        expect(controller.currentMode, modes.capture);
        expect(controller.currentState, states.capturing);
        expect(controller.lastCommand, commands.run);
      });
    });

    group('stateMan, exit from : state=persisting', () {
      test('state=waiting mode=capture command=stop', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.persisting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.stop,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.persist);
        expect(controller.currentState, states.stopped);
        expect(controller.lastCommand, commands.stop);
      });
      test('state=waiting mode=capture command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.persisting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.capture,
        );

        expect(controller.currentMode, modes.persist);
        expect(controller.currentState, states.persisting);
        expect(controller.lastCommand, commands.start);
      });
      test('state=waiting mode=persist command=start', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.persisting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.start,
          mode: modes.persist,
        );

        expect(controller.currentMode, modes.persist);
        expect(controller.currentState, states.persisting);
        expect(controller.lastCommand, commands.start);
      });
      test('state=waiting mode=capture command=run', () {
        final controller = Get.find<HomeController>();
        controller.currentMode = modes.none;
        controller.currentState = states.persisting;
        controller.lastCommand = commands.none;

        controller.stateMan(
          command: commands.run,
          mode: modes.persist,
        );

        expect(controller.currentMode, modes.persist);
        expect(controller.currentState, states.persisting);
        expect(controller.lastCommand, commands.run);
      });
    });
  });
  //final firestore = MockFirestoreInstance();
  // final userCredential = MockUserCredential();
  //BindingsBuilder binding;
  //final auth = MockFirebaseAuth();
  //final dataBase = MockDatabase();
  // group('Test auth controller', () {
  //   setUpAll(() async {
  //     binding = BindingsBuilder(() {
  //       Get.put<AuthController>(
  //         AuthController(auth: auth, dataBase: dataBase),
  //         permanent: false,
  //       );
  //     });
  //     binding.builder();
  //   });
  //   tearDown(() {
  //     Get.delete<AuthController>();
  //   });
  //   test('check controller initialize', () async {
  //     final controller = Get.find<AuthController>();
  //     expect(controller.initialized, true);
  //   });
  //   test('CreateUser no credentials', () async {
  //     final controller = Get.find<AuthController>();
  //     controller.emailText = '';
  //     controller.nameText = '';
  //     controller.passwordText = '';
  //     var result = await controller.createUser();
  //     expect(
  //         result,
  //         'User credentials must be properly'
  //         'formed and not empty');
  //   });
  //     });
}
