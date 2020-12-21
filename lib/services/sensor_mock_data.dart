// @dart=2.9
import 'dart:async';
import 'dart:math';

import 'package:accelerometer/models/sensor_model.dart';

class SensorMockData {
  var data = <SensorModel>[];
  var lastDT = DateTime.now();
  var firstRun = false;

  var rng = Random();

  Stream<double> timedCounter({
    Duration samplePeriod = const Duration(seconds: 1),
    int maxCount = 10,
    double amplitude = 1.0,
    double offset = 0.0,
    double period = 1000.0,
  }) {
    var streamController = StreamController<double>();
    Timer timer = Timer(Duration(seconds: 1), () {});
    var domainVal = 0.0;
    void tick(Timer timer) {
      var modDV = domainVal % period;
      double measureVal;
      var randNumber = (rng.nextDouble() - 0.5) * amplitude * 1.5;
      if (modDV <= period / 4) {
        measureVal = amplitude / 2 * modDV + randNumber;
      } else if (modDV <= 3 * period / 4) {
        measureVal = -1.0 * amplitude / 2 * modDV + 2 * amplitude + randNumber;
      } else {
        measureVal = amplitude / 2 * modDV - 4 * amplitude + randNumber;
      }
      measureVal += offset;
      domainVal++;
      streamController
          .add(measureVal); // Ask stream to send counter values as event.
      if (maxCount >= 0 && domainVal >= maxCount) {
        timer.cancel();
        // Ask stream to shut down and tell listeners.
        //streamController.close();
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
      //if (timer != null) {
      timer.cancel();
      //timer = null;
    }

    streamController = StreamController<double>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: resumeTimer,
        onCancel: stopTimer);
    return streamController.stream;
  }

  void startStream({
    int samplePeriod = 100,
    int maxCount = 50,
    double amplitude = 1.0,
    double offset = 0.0,
    double period = 0.0,
  }) {
    timedCounter(
      samplePeriod: Duration(milliseconds: samplePeriod),
      amplitude: amplitude,
      offset: offset,
      period: period,
      maxCount: maxCount,
    );
  }
}
