import 'dart:async';
import 'dart:math';

import 'package:accelerometer/models/sensor_model.dart';

class Sensor {
  Sensor() {
    //data.clear();
  }
  var data = <SensorModel>[];
  var lastDT = DateTime.now();
  var firstRun = false;
  Stream<double> sensorStream;
  var rng = Random();

  List<SensorModel> getDummyData(int bufSize) {
    print('getDummyData');
    if (!firstRun) {
      updateDummyData(bufSize);
      firstRun = true;
    }
    if (data.length < bufSize) {
      return data;
    } else {
      var end = data.length - 1;
      var start = end - bufSize + 1;
      return data.sublist(start, end);
    }
  }

  void updateDummyData(int bufSize) {
    //var now = DateTime.now();
    print('updateDummyData');
    var duration = Duration(seconds: 1);

    for (int i = 0; i < bufSize; i++) {
      lastDT = lastDT.add(duration);
      print('lastDT: $lastDT');
      var randNr = rng.nextDouble() * 2;
      var value = i < bufSize / 2
          ? 0.0 + i + randNr
          : (bufSize / 2).toDouble() - i + randNr;
      var record = SensorModel(
        channel: 0,
        timeStamp: lastDT,
        value: value,
      );
      data.add(record);
    }
  }

  void updateDummyData2(int bufSize) {
    //startStream();
    //listenStream();
  }

  Stream<double> timedCounter({
    Duration samplePeriod,
    int maxCount,
    double amplitude,
    double offset,
    double period,
  }) {
    var streamController = StreamController<double>();
    Timer timer;
    var domainVal = 0.0;
    void tick(Timer timer) {
      var modDV = domainVal % period;
      var measureVal;
      if (modDV <= period / 4) {
        measureVal = modDV; // + rng.nextDouble();
      } else if (modDV <= period / 2) {
        measureVal = period / 2 - modDV; // + rng.nextDouble();
      } else if (modDV <= 3 * period / 4) {
        measureVal =
            -1.0 * amplitude + 3 * period / 4 - modDV; // + rng.nextDouble();
      } else {
        measureVal = -1.0 * amplitude + modDV - 3 * period / 4;
      }
      domainVal++;
      streamController
          .add(measureVal); // Ask stream to send counter values as event.
      if (domainVal >= maxCount) {
        timer.cancel();
        streamController.close(); // Ask stream to shut down and tell listeners.
      }
    }

    void startTimer() {
      timer = Timer.periodic(samplePeriod, tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    streamController = StreamController<double>(
        onListen: startTimer,
        onPause: stopTimer,
        onResume: startTimer,
        onCancel: stopTimer);

    return streamController.stream;
  }

  void startStream(int nrValues) {
    sensorStream = timedCounter(
      samplePeriod: const Duration(milliseconds: 100),
      amplitude: 2.0,
      offset: 0,
      period: 8,
      maxCount: nrValues,
    );
  }

  // void listenStream() {
  //   sensorStream.listen((x) {
  //     print('timedCounter1 $x');
  //     var record = SensorModel(
  //       channel: 0,
  //       timeStamp: DateTime.now(),
  //       value: x,
  //     );
  //     data.add(record);
  //   });
  // }
}
