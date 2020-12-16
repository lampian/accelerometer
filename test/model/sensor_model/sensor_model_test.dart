import 'package:accelerometer/models/sensor_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// class WeakPasswordException extends FirebaseAuthException {
//   @override
//   String get code => 'weak-password';
// }

//class MockDatabase extends Mock implements Database {}

void main() {
  BindingsBuilder binding;

  //group('json', () {
  // setUpAll(() async {
  //   binding = BindingsBuilder(() {
  //     Get.put<HomeController>(
  //       HomeController(),
  //       permanent: false,
  //     );
  //   });
  //   binding.builder();
  // });
  // tearDown(() {
  //   //Get.delete<HomeController>();
  // });
  group('stateMan, exit from : state=stopped', () {
    test('rms', () {
      var model = SensorModel(
        channel: 1,
        timeStamp: DateTime(2020, 12, 1, 12, 30, 20, 123),
        valueX: 2,
        valueY: -3,
        valueZ: 4,
      );
      double x = model.rms();
      expect(model.channel, 1);
      expect(model.timeStamp, DateTime(2020, 12, 1, 12, 30, 20, 123));
      expect(model.valueX, 2.0);
      expect(model.valueY, -3.0);
      expect(model.valueZ, 4.0);
      expect(x, closeTo(5.385, 0.001));
    });
    test('mms2rms ', () {
      var model = SensorModel(
        channel: 1,
        timeStamp: DateTime(2020, 12, 1, 12, 30, 20, 123),
        valueX: 2,
        valueY: -3,
        valueZ: 4,
      );
      int x = model.mms2rms();
      expect(model.channel, 1);
      expect(model.timeStamp, DateTime(2020, 12, 1, 12, 30, 20, 123));
      expect(model.valueX, 2.0);
      expect(model.valueY, -3.0);
      expect(model.valueZ, 4.0);
      expect(x, 5385);
    });
    test('toJsonMap', () {
      var refValue = {
        "c": 1,
        "t": 1606818620123,
        "d": 123456,
        "v": 5385,
      };

      var model = SensorModel(
        channel: 1,
        timeStamp: DateTime(2020, 12, 1, 12, 30, 20, 123),
        valueX: 2,
        valueY: -3,
        valueZ: 4,
      );
      Map<String, dynamic> x = model.toJsonMap('123456');
      expect(x, refValue);
    });
    test('toJsonBase64', () {
      var model = SensorModel(
        channel: 1,
        timeStamp: DateTime(2020, 12, 1, 12, 30, 20, 123),
        valueX: 2,
        valueY: -3,
        valueZ: 4,
      );
      var x = model.toJsonBase64('123456');
      var refStr =
          'eyJ0IjoxNjA2ODE4NjIwMTIzLCJkIjoxMjM0NTYsImMiOjEsInYiOjUzODV9';
      expect(x, refStr);
    });
  });
}
