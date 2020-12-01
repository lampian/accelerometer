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

final triggerType = ['Level', 'Timer', 'Auto'];

class HomeController extends GetxController {
  var lastCommand = commands.stop;
  var currentState = states.stopped;
  var currentMode = modes.capture;
  //var triggerText = triggerType[0];
  var stateChanged = false;
  var modeChanged = false;
  var sensor = Sensor();
  StreamSubscription subscription;
  var aList = List<SensorModel>();
  var startLevel = 7.0;
  var startPosEdge = true;
  var stopLevel = -7.5;
  var stopPosEdge = false;
  var updateData = false;

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

  void initController() {
    //if already listening to stream ignore
    if (subscription != null) return;
    subscription = listenToStream();
    //subscription.pause();
    stateMan(command: lastCommand, mode: currentMode);
    stateExecute(stateChanged: stateChanged, modeChanged: modeChanged);
    cmndText.value = cmndsText.first;
  }

  StreamSubscription<double> listenToStream() {
    return sensor.sensorStream.listen((x) {
      var record = SensorModel(
        channel: 0,
        timeStamp: DateTime.now(),
        value: x,
      );
      aList.add(record);
      if (updateData) {
        update();
      }
      handleLevelTrig(record.value);
    });
  }

  void handleLevelTrig(double value) {
    if (currentState == states.waiting) {
      if (trigStartText.value == triggerType[0]) {
        if (startPosEdge) {
          if (value > startLevel) {
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
          }
        } else {
          if (value < startLevel) {
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
          }
        }
      }
    } else if (currentState == states.capturing) {
      if (trigStopText.value == triggerType[0]) {
        if (stopPosEdge) {
          if (value > stopLevel) {
            stateMan(command: commands.stop, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            cmndText.value = cmndsText.first;
          }
        } else {
          if (value < stopLevel) {
            stateMan(command: commands.stop, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            cmndText.value = cmndsText.first;
          }
        }
      }
    }
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

  // execute acions required when change of state.
  // [ 'Level', 'Timer', 'Auto'];
  void stateExecute({bool modeChanged, bool stateChanged}) {
    if (!stateChanged) return;
    switch (currentState) {
      case states.stopped:
        //subscription.pause();
        updateData = false;
        break;
      case states.waiting:
        if (trigStartText.value == triggerType[2] &&
            trigStopText.value == triggerType[2]) {
          //subscription.resume();
          updateData = true;
          stateMan(command: commands.start, mode: currentMode);
          stateExecute(modeChanged: false, stateChanged: true);
        } else if (trigStartText.value == triggerType[1] &&
            trigStopText.value == triggerType[2]) {
          enableStartTimeout();
        } else if (trigStartText.value == triggerType[1] &&
            trigStopText.value == triggerType[1]) {
          enableStartStopTimeout();
        } else if (trigStartText.value == triggerType[2] &&
            trigStopText.value == triggerType[1]) {
          enableStopTimeout();
        } else if (trigStartText.value != triggerType[0] &&
            trigStopText.value == triggerType[0]) {
          updateData = true;
          stateMan(command: commands.start, mode: currentMode);
          stateExecute(modeChanged: false, stateChanged: true);
        }

        break;
      case states.capturing:
        //subscription.resume();
        updateData = true;
        break;
      case states.persisting:
        //subscription.resume();
        updateData = true;
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

  // void handleStopGo() {
  //   if (subscription.isPaused) {
  //     subscription.resume();
  //   } else {
  //     subscription.pause();
  //   }
  // }

  final cmndsText = ['Run', 'Stop'];
  var cmndText = 'Stop'.obs;

  void handleCmndPressed() {
    var idx = cmndsText.indexOf(cmndText.value);
    if (idx < cmndsText.length - 1) {
      cmndText.value = cmndsText[idx + 1];
      stateMan(command: commands.run, mode: currentMode);
      stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    } else {
      cmndText.value = cmndsText.first;
      stateMan(command: commands.stop, mode: currentMode);
      stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    }
  }

  //final triggersText = const ['None', 'Auto', 'Timer', 'Level'];
  var trigStartText = 'Auto'.obs;
  var trigStopText = 'Auto'.obs;

  void handleTrigStartPressed() {
    //dont modify trigger when running
    if (currentState != states.stopped) return;
    trigStartText.value = getNextTrigLabel(trigStartText.value);
  }

  void handleTrigStopPressed() {
    //dont modify trigger when running
    if (currentState != states.stopped) return;
    trigStopText.value = getNextTrigLabel(trigStopText.value);
  }

  String getNextTrigLabel(String currentLabel) {
    var found = false;
    var assigned = false;
    var returnStr = triggerType[0];
    triggerType.forEach((value) {
      if (found && !assigned) {
        returnStr = value;
        assigned = true;
      }
      if (value == currentLabel && !assigned) {
        found = true;
      }
    });
    if (!assigned) {
      returnStr = triggerType[0];
    }
    return returnStr;
  }

  //TODO find better way to do this
  void mapTrig() {}

  final modesText = const ['Capture', 'Persist'];
  var modeText = 'Capture'.obs;

  void handleModePressed() {
    if (currentState != states.stopped) return;
    var idx = modesText.indexOf(modeText.value);
    if (idx < modesText.length - 1) {
      modeText.value = modesText[idx + 1];
    } else {
      modeText.value = modesText.first;
    }
  }

  var waitForDuration = Duration(seconds: 7);

  enableStartTimeout() {
    print('start timer: ${DateTime.now()}');
    return Timer(Duration(seconds: 7), startTimerCallback);
  }

  void startTimerCallback() {
    print('start timer: ${DateTime.now()}');
    stateMan(command: commands.start, mode: currentMode);
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
  }

  enableStartStopTimeout() {
    print('start timer: ${DateTime.now()}');
    return Timer(Duration(seconds: 7), startStopTimerCallback);
  }

  void startStopTimerCallback() {
    print('start timer: ${DateTime.now()}');
    stateMan(command: commands.start, mode: currentMode);
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    enableStopTimeout();
  }

  enableStopTimeout() {
    print('stop timer: ${DateTime.now()}');
    stateMan(command: commands.start, mode: currentMode);
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    return Timer(Duration(seconds: 10), stopTimerCallback);
  }

  void stopTimerCallback() {
    print('stop timer: ${DateTime.now()}');
    cmndText.value = cmndsText.first;
    stateMan(command: commands.stop, mode: currentMode);
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
  }
}
