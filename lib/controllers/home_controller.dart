import 'dart:async';
import 'dart:io';

import 'package:accelerometer/models/sensor_model.dart';
import 'package:accelerometer/services/sensor.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get_connect/http/src/utils/utils.dart';

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
  viewing,
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
  var startLevel = 8.0;
  var startPosEdge = true;
  var stopLevel = -8.0;
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
        index: aList.length,
      );

      if (updateData) {
        aList.add(record);
        update();
        //stdout.write(".");
      }

      handleLevelTrig(record.value);
    });
  }

  //List<charts.Series<SensorModel, DateTime>> getSeriesList() {
  List<charts.Series<SensorModel, int>> getSeriesList() {
    return [
      //charts.Series<SensorModel, DateTime>(
      charts.Series<SensorModel, int>(
        id: 'dummy',
        //domainFn: (SensorModel dataPoint, _) => dataPoint.timeStamp,
        domainFn: (SensorModel dataPoint, _) => dataPoint.index,
        measureFn: (SensorModel dataPoint, _) => dataPoint.value,
        //return last x records from list
        data: returnData(),
      ),
    ];
  }

  List<SensorModel> returnData() {
    var len = aList.length;
    var zoom = 40;
    if (currentState == states.viewing ||
        currentState == states.stopped ||
        currentState == states.waiting) {
      print('returnData - viewing or stopped or waiting');
      print('data points ${aList.length}');
      var x = 0;
      aList.forEach((element) {
        element.index = x;
        x++;
      });
      return aList;
    } else if (zoom <= len) {
      var shortList = aList.sublist(len - zoom);
      var x = 0;
      shortList.forEach((element) {
        element.index = x;
        x++;
      });
      return shortList;
    } else {
      return aList;
    }
  }

  // var dmnViewPortX1 = 0;
  // var dmnViewPortX2 = 0;
  // List<SensorModel> returnData() {
  //   var len = aList.length;
  //   var zoom = 40;
  //   if (currentState == states.stopped) {
  //     dmnViewPortX1 = 0;
  //     dmnViewPortX2 = aList.length;
  //     return aList;
  //   } else if (zoom <= len) {
  //     dmnViewPortX1 = len - zoom;
  //     dmnViewPortX2 = len - 1;
  //   } else if (len > 0) {
  //     dmnViewPortX1 = 0;
  //     dmnViewPortX2 = len - 1;
  //   }

  //   return aList;
  // }

  void handleLevelTrig(double value) {
    var levelTriggered = false;
    if (currentState == states.waiting) {
      // level start
      if (trigStartText.value == triggerType[0]) {
        if (startPosEdge) {
          if (value > startLevel) {
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            levelTriggered = true;
          }
        } else {
          if (value < startLevel) {
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            levelTriggered = true;
          }
        }
        // check if timer stop trigger active
        if (levelTriggered && trigStopText.value == triggerType[1]) {
          enableStopTimeout();
        }
      }
    } else if (currentState == states.capturing) {
      //level stop
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
          currentState = states.viewing;
        }
        break;
      case states.persisting:
        currentMode = modes.persist;
        if (command == commands.stop) {
          currentState = states.viewing;
        }
        break;
      case states.viewing:
        if (command == commands.run) {
          currentState = states.waiting;
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
        aList.clear();
        //auto start - auto stop
        if (trigStartText.value == triggerType[2] &&
            trigStopText.value == triggerType[2]) {
          //subscription.resume();
          updateData = true;
          stateMan(command: commands.start, mode: currentMode);
          stateExecute(modeChanged: false, stateChanged: true);
          //timer start - auto stop
        } else if (trigStartText.value == triggerType[1] &&
            trigStopText.value == triggerType[2]) {
          enableStartTimeout();
          // timer start - timer stop
        } else if (trigStartText.value == triggerType[1] &&
            trigStopText.value == triggerType[1]) {
          enableStartStopTimeout();
          // auto start - timerstop
        } else if (trigStartText.value == triggerType[2] &&
            trigStopText.value == triggerType[1]) {
          enableStopTimeout();
          // not level start - level stop
        } else if (trigStartText.value != triggerType[0] &&
            trigStopText.value == triggerType[0]) {
          updateData = true;
          stateMan(command: commands.start, mode: currentMode);
          stateExecute(modeChanged: false, stateChanged: true);
          // level start - timer stop
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
      case states.viewing:
        print('states: viewing');
        updateData = false;
        update();
        break;
      default:
        break;
    }
    stateChanged = false;
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
