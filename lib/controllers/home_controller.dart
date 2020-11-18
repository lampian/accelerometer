import 'dart:async';

import 'package:accelerometer/models/sensor_model.dart';
import 'package:accelerometer/services/sensor.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//state machine states enums
enum commands {
  none,
  run,
  start,
  stop,
}

enum modes {
  none,
  capture,
  persist,
}

enum states {
  stopped,
  waiting,
  capturing,
  persisting,
}

class HomeController extends GetxController {
  var lastCommand = commands.stop;
  var currentState = states.stopped;
  var currentMode = modes.capture;
  var sensor = Sensor();
  StreamSubscription subscription;
  var aList = List<SensorModel>();

  @override
  void onInit() {
    super.onInit();
    // aList.add(SensorModel(
    //   channel: 0,
    //   timeStamp: DateTime.now(),
    //   value: 0,
    // ));
    sensor.startStream(100);
    //subscription = listenToStream();
  }

  void initStream() {
    //if already listening to stream ignore
    if (subscription != null) return;
    subscription = listenToStream();
  }

  StreamSubscription<double> listenToStream() {
    return sensor.sensorStream.listen((x) {
      print('listen to timedCounter1 $x');
      var record = SensorModel(
        channel: 0,
        timeStamp: DateTime.now(),
        value: x,
      );
      aList.add(record);
      update();
    });
  }

  void stateMan({commands command, modes mode}) {
    lastCommand = command;

    switch (currentState) {
      case states.stopped:
        currentMode = mode;
        if (command == commands.run) {
          currentState = states.waiting;
        }
        break;
      case states.waiting:
        currentMode = mode;
        if (command == commands.stop) {
          currentState = states.stopped;
        } else if (command == commands.start && mode == modes.capture) {
          currentState = states.capturing;
        } else if (command == commands.start && mode == modes.persist) {
          currentState = states.persisting;
        }
        break;
      case states.capturing:
        currentMode = modes.capture;
        if (command == commands.stop) {
          currentState = states.stopped;
        }
        break;
      case states.persisting:
        currentMode = modes.persist;
        if (command == commands.stop) {
          currentState = states.stopped;
        }
        break;
      default:
        currentMode = mode;
        currentState = states.stopped;
        break;
    }
  }

  List<charts.Series<SensorModel, DateTime>> getSeriesList() {
    return [
      charts.Series<SensorModel, DateTime>(
        id: 'dummy',
        domainFn: (SensorModel dataPoint, _) => dataPoint.timeStamp,
        measureFn: (SensorModel dataPoint, _) => dataPoint.value,
        //data: sensor.getDummyData(30),
        data: aList,
      ),
    ];
  }

  void updateData() {
    //sensor.updateDummyData2(30);
    //update();
  }
}
