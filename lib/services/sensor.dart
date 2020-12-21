// @dart=2.9
import 'dart:async';
import 'dart:math';

import 'package:accelerometer/models/sensor_model.dart';
import 'package:sensors/sensors.dart';

class Sensor {
  var data = <SensorModel>[];
  var lastDT = DateTime.now();
  var firstRun = false;
  Stream<AccelerometerEvent> sensorStream;
  var rng = Random();

  Stream<AccelerometerEvent> timedCounter({Duration samplePeriod}) {
    var streamController = StreamController<AccelerometerEvent>();
    Timer timer = Timer(Duration(seconds: 1), () {});

    // timer fires at period samplePeriod which should be longer
    // than sample rate of accelerometer, leaving samples in cash
    // cashed data is averaged over period and put into stream
    void tick(Timer timer) {
      var xVal = 0.0;
      var yVal = 0.0;
      var zVal = 0.0;
      eventList.forEach((element) {
        xVal += element.x;
        yVal += element.y;
        zVal += element.z;
      });
      var len = eventList.length;

      if (len > 0) {
        var measureVal = AccelerometerEvent(
          xVal / len,
          yVal / len,
          zVal / len,
        );
        // Ask stream to send counter values as event.
        streamController.add(measureVal);
      }

      eventList.clear();
    }

    void startTimer() {
      timer = Timer.periodic(samplePeriod ?? Duration(seconds: 1), tick);
    }

    void resumeTimer() {
      timer = Timer.periodic(samplePeriod ?? Duration(seconds: 1), tick);
    }

    void stopTimer() {
      //if (timer != null) {
      timer.cancel();
      //timer = null;
      //}
      streamController.close();
    }

    streamController = StreamController<AccelerometerEvent>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: resumeTimer,
        onCancel: stopTimer);

    return streamController.stream;
  }

  // sample rate of accelerometer around 20ms ie 50samples/sec
  // 1000 samples at around 20 sec smple rate
  // swap over buffer most propably a overkill
  var eventList = <AccelerometerEvent>[];
  void listenToEvents() {
    accelerometerEvents.listen((event) {
      eventList.add(event);
      //print('accel event ${DateTime.now()}');
    });
  }

  void startStream({int samplePeriod}) {
    sensorStream = timedCounter(
      samplePeriod: Duration(milliseconds: samplePeriod ?? 100),
    );
    listenToEvents();
  }
}
