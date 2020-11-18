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
  var stateChanged = false;
  var modeChanged = false;
  var sensor = Sensor();
  StreamSubscription subscription;
  var aList = List<SensorModel>();

  @override
  void onInit() {
    super.onInit();
    sensor.startStream(
      amplitude: 5.0,
      maxCount: -1,
      offset: 0.0,
      period: 8.0,
      samplePeriod: 50,
    );
  }

  void initStream() {
    //if already listening to stream ignore
    if (subscription != null) return;
    subscription = listenToStream();
  }

  StreamSubscription<double> listenToStream() {
    return sensor.sensorStream.listen((x) {
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
    var prevState = currentState;
    var prevMode = currentMode;
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
    stateChanged = prevState == currentState ? false : true;
    modeChanged = prevMode == currentMode ? false : true;
  }

  void stateExecute({bool modeChanged, bool stateChanged}) {
    if (!stateChanged) return;
    switch (currentState) {
      case states.stopped:
        subscription.pause();
        break;
      case states.waiting:
        break;
      case states.capturing:
        subscription.resume();
        break;
      case states.persisting:
        subscription.resume();
        break;
      default:
        break;
    }
    stateChanged = false;
  }

  List<charts.Series<SensorModel, DateTime>> getSeriesList() {
    return [
      charts.Series<SensorModel, DateTime>(
        id: 'dummy',
        domainFn: (SensorModel dataPoint, _) => dataPoint.timeStamp,
        measureFn: (SensorModel dataPoint, _) => dataPoint.value,
        //return last x records from list
        data: returnEnd(),
      ),
    ];
  }

  List<SensorModel> returnEnd() {
    var len = aList.length;
    var zoom = 40;
    if (zoom <= len) {
      return aList.sublist(len - zoom);
    } else
      return aList;
  }

  void handleStopGo() {
    if (subscription.isPaused) {
      subscription.resume();
    } else {
      subscription.pause();
    }
  }

  var cmndButton = false;
  static const run = 'Run';
  static const stop = 'Stop';
  var cmndText = 'Run'.obs;

  void handleCmndPressed() {
    if (cmndText.value == run) {
      cmndText.value = stop;
      stateMan(command: commands.stop, mode: currentMode);
      stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    } else {
      cmndText.value = run;
      stateMan(command: commands.run, mode: currentMode);
      stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    }
  }
}
