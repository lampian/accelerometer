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

  Stream<AccelerometerEvent> timedCounter({
    Duration samplePeriod,
    int maxCount,
    double amplitude,
    double offset,
    double period,
  }) {
    var streamController = StreamController<AccelerometerEvent>();
    Timer timer;
    var domainVal = 0.0;
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
      domainVal++;
      //maxCount > 0 is th e number of sampples to take
      //neg values indicates neverending stream
      if (maxCount >= 0 && domainVal >= maxCount) {
        timer.cancel();
        streamController.close();
      }
    }

    void startTimer() {
      timer = Timer.periodic(samplePeriod, tick);
    }

    void resumeTimer() {
      timer = Timer.periodic(samplePeriod, tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    streamController = StreamController<AccelerometerEvent>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: resumeTimer,
        onCancel: stopTimer);

    return streamController.stream;
  }

  //TODO dual buffer
  //implement 2 buffers alternating to avoid glitches?
  var eventList = <AccelerometerEvent>[];
  void listenToEvents() {
    accelerometerEvents.listen((event) {
      eventList.add(event);
    });
  }

  void startStream({
    int samplePeriod,
    int maxCount,
    double amplitude,
    double offset,
    double period,
  }) {
    sensorStream = timedCounter(
      samplePeriod: Duration(milliseconds: samplePeriod),
      amplitude: amplitude,
      offset: offset,
      period: period,
      maxCount: maxCount,
    );
    listenToEvents();
  }
}
