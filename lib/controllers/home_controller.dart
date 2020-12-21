// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:accelerometer/models/sensor_model.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/services/sensor.dart';
import 'package:accelerometer/views/level_trig_setup.dart';
import 'package:accelerometer/views/timing_setup.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:sensors/sensors.dart';

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
  HomeController() {
    //subscription = listenToStream();
    mqttMan = MqttManager();
  }
  MqttManager mqttMan;
  StreamSubscription subscription;

  var lastCommand = commands.stop;
  var currentState = states.stopped;
  var currentMode = modes.capture;
  var stateChanged = false;
  var modeChanged = false;
  var sensor = Sensor();
  var aList = <SensorModel>[];
  var startLevel = 8.0; //must be >= 0
  var startPosEdge = true;
  var stopLevel = 4.0; //must be >= 0
  var stopPosEdge = false;
  var updateData = false;
  var persistData = false;
  var zoomMin = 0.0;
  var zoomMax = 100.0;
  var samplePeriod = 1000; //must be > 0

  //these two values are important to keep gcp costs in budget
  //max sample per seconds = 1
  //transmitted every 15 seconds, ie 15 samples cached and published
  //every 15 seconds. Faster on average over 30 days might incure gcp costs
  final mqttBufTrigLength = 15;
  final samplingTreshold = 1000; //msec

  var _waiting = false.obs;
  bool get waiting => _waiting.value;
  set waiting(bool value) {
    _waiting.value = value;
    update(['cmndButton']);
  }

  Map<dynamic, dynamic> levelTrigData() {
    return {
      'startLevel': startLevel,
      'startPosEdge': startPosEdge,
      'stopLevel': stopLevel,
      'stopPosEdge': stopPosEdge,
    };
  }

  setLevelTrigData(Map<dynamic, dynamic> map) {
    startLevel = map['startLevel'] as double;
    startPosEdge = map['startPosEdge'] as bool;
    stopLevel = map['stopLevel'] as double;
    stopPosEdge = map['stopPosEdge'] as bool;
  }

  @override
  void onInit() {
    super.onInit();
    sensor.startStream(samplePeriod: samplePeriod);
    mqttMan = Get.find<MqttManager>();
  }

  @override
  void onClose() {
    super.onClose();
    subscription.cancel();
  }

  void initController() {
    //if already listening to stream ignore
    if (subscription != null) return;
    subscription = listenToStream();
    //subscription.pause();
    stateMan(command: lastCommand, mode: currentMode);
    stateExecute(stateChanged: stateChanged, modeChanged: modeChanged);
    cmndText = cmndsText.first;
  }

  StreamSubscription<AccelerometerEvent> listenToStream() {
    return sensor.sensorStream.listen((eventData) {
      var record = SensorModel(
        channel: 0,
        timeStamp: DateTime.now(),
        valueX: eventData.x,
        valueY: eventData.y,
        valueZ: eventData.z,
        index: aList.length,
      );

      if (updateData) {
        aList.add(record);
        update();
        //stdout.write(".");
        if (persistData) {
          print('perisist: ${record.timeStamp}');
          mqttPublish(record, false);
        }
      }

      handleLevelTrig(record);
    });
  }

  void restartStream() {
    // if (subscription != null) {
    subscription?.cancel();
    //   subscription = null;
    // }
    sensor.startStream(samplePeriod: samplePeriod);
    initController();
  }

  //List<charts.Series<SensorModel, DateTime>> getSeriesList() {
  List<charts.Series<SensorModel, int>> getSeriesList(String chan) {
    if (chan == 'x') {
      return [
        //charts.Series<SensorModel, DateTime>(
        charts.Series<SensorModel, int>(
          id: 'dummy',
          //domainFn: (SensorModel dataPoint, _) => dataPoint.timeStamp,
          domainFn: (SensorModel dataPoint, _) => dataPoint.index ?? 0,
          measureFn: (SensorModel dataPoint, _) => dataPoint.valueX ?? 0,
          //return last x records from list
          data: returnData(),
        ),
      ];
    } else if (chan == 'y') {
      return [
        //charts.Series<SensorModel, DateTime>(
        charts.Series<SensorModel, int>(
          id: 'dummy',
          //domainFn: (SensorModel dataPoint, _) => dataPoint.timeStamp,
          domainFn: (SensorModel dataPoint, _) => dataPoint.index ?? 0,
          measureFn: (SensorModel dataPoint, _) => dataPoint.valueY ?? 0,
          //return last x records from list
          data: returnData(),
        ),
      ];
    } else {
      return [
        //charts.Series<SensorModel, DateTime>(
        charts.Series<SensorModel, int>(
          id: 'dummy',
          //domainFn: (SensorModel dataPoint, _) => dataPoint.timeStamp,
          domainFn: (SensorModel dataPoint, _) => dataPoint.index ?? 0,
          measureFn: (SensorModel dataPoint, _) => dataPoint.valueZ ?? 0,
          //return last x records from list
          data: returnData(),
        ),
      ];
    }
  }

  var dmnViewPortX1 = 0;
  var dmnViewPortX2 = 1;
  List<SensorModel> returnData() {
    var len = aList.length;
    var zoom = 40;
    if (currentState == states.viewing) {
      print('returnData - viewing');
      print('data points ${aList.length}');
      var start = zoomMin * aList.length / 100.0;
      var stop = zoomMax * aList.length / 100.0;
      var zoomList = aList.sublist(start.toInt(), stop.toInt());
      dmnViewPortX1 = start.toInt();
      dmnViewPortX2 = stop.toInt() - 1;
      var x = dmnViewPortX1;
      zoomList.forEach((element) {
        element.index = x;
        x++;
      });
      return zoomList;
    } else if (currentState == states.stopped ||
        currentState == states.waiting) {
      print('returnData - stopped or waiting');
      print('data points ${aList.length}');
      dmnViewPortX1 = 0;
      dmnViewPortX2 = zoom - 1; //len > 1 ? len - 1 : 1;
      // var x = 0;
      // aList.forEach((element) {
      //   element.index = x;
      //   x++;
      // });
      return aList;
    } else if (zoom < len) {
      var shortList = aList.sublist(len - zoom);
      dmnViewPortX1 = 0;
      dmnViewPortX2 = zoom - 1;
      var x = 0;
      shortList.forEach((element) {
        element.index = x;
        x++;
      });
      return shortList;
    } else {
      dmnViewPortX1 = 0;
      dmnViewPortX2 = zoom - 1; //len - 1;
      return aList;
    }
  }

  void handleLevelTrig(SensorModel values) {
    var levelTriggered = false;
    var value = values.rms();
    if (currentState == states.waiting) {
      // level start
      if (trigStartText.value == triggerType[0]) {
        if (startPosEdge) {
          if (value > startLevel) {
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            levelTriggered = true;
            print('Start level triggered on positive edge with value '
                '$value and trigger level $startLevel');
          }
        } else {
          if (value < startLevel) {
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            levelTriggered = true;
            print('Start level triggered on negative edge with value '
                '$value and trigger level $startLevel');
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
            cmndText = cmndsText.first;
            print('Stop level triggered on positive edge with value '
                '$value and trigger level $stopLevel');
          }
        } else {
          if (value < stopLevel) {
            stateMan(command: commands.stop, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            cmndText = cmndsText.first;
            print('Stop level triggered on negative edge with value '
                '$value and trigger level $stopLevel');
          }
        }
      }
    }
  }

  void stateMan({commands command = commands.none, modes mode = modes.none}) {
    lastCommand = command;
    var prevState = currentState;
    var prevMode = currentMode;
    switch (currentState) {
      case states.stopped:
        currentMode = mode;
        if (command == commands.run) {
          currentState = states.waiting;
        } else if (command == commands.run) {
          currentMode = mode;
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
        } else if (command == commands.none && mode != modes.none) {
          currentMode = mode;
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
  void stateExecute({bool modeChanged = false, bool stateChanged = false}) {
    if (stateChanged) {
      switch (currentState) {
        case states.stopped:
          //subscription.pause();
          updateData = false;
          break;
        case states.waiting:
          aList.clear();
          waiting = true;
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
            // timer start - level stop
          } else if (trigStartText.value == triggerType[1] &&
              trigStopText.value == triggerType[0]) {
            enableStartTimeout();
            // auto start - timerstop
          } else if (trigStartText.value == triggerType[2] &&
              trigStopText.value == triggerType[1]) {
            enableStopTimeout();
            // auto start - level stop
          } else if (trigStartText.value == triggerType[2] &&
              trigStopText.value == triggerType[0]) {
            updateData = true;
            stateMan(command: commands.start, mode: currentMode);
            stateExecute(modeChanged: false, stateChanged: true);
            // level start => level handler will take care of stop
          } else if (trigStartText.value == triggerType[0]) {
            // updateData = true;
            // stateMan(command: commands.start, mode: currentMode);
            // stateExecute(modeChanged: false, stateChanged: true);
            print(' level trigger');
          } else {
            print('home controller - condition not detected');
            throw ProcessException;
          }
          break;
        case states.capturing:
          //subscription.resume();
          waiting = false;
          updateData = true;
          break;
        case states.persisting:
          //subscription.resume();
          waiting = false;
          updateData = true;
          break;
        case states.viewing:
          print('states: viewing');
          zoomMin = 0.0;
          zoomMax = 100.0;
          updateData = false;
          update();
          break;
        default:
          break;
      }
      stateChanged = false;
    }
    if (modeChanged) {
      if (currentMode == modes.capture) {
        //mode changed to capture
        //deactivate mqqtt client
        mqttMan?.disconnect();
        persistData = false;
      } else if (currentMode == modes.persist) {
        //mode changed to persist
        if (Duration(milliseconds: samplePeriod) <
            Duration(milliseconds: samplingTreshold)) {
          Get.snackbar(
              'Error:',
              'Sample rate above minimum threshold,'
                  'adjust the rate by long pressing Run control',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.backgroundColor, //Colors.grey[700],
              duration: Duration(seconds: 5));
          handleModePressed(); //force mode back
          return;
        }

        //activate mqtt client
        if (mqttMan?.initializeMQTTClient() ?? false) {
          mqttMan?.connect();
          persistData = true;
        } else {
          Get.snackbar(
              'Error:', 'Mqtt initialisation failed - configure device',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.backgroundColor, //Colors.grey[700],
              duration: Duration(seconds: 5));
          handleModePressed(); //force mode back
          return;
        }
      }
      modeChanged = false;
    }
  }

  final cmndsText = ['Run', 'Stop'];
  var _cmndText = 'Stop'.obs;
  String get cmndText => _cmndText.value;
  set cmndText(String val) {
    _cmndText.value = val;
    update(['cmndButton']);
  }

  void handleCmndPressed() {
    var idx = cmndsText.indexOf(_cmndText.value);
    if (idx < cmndsText.length - 1) {
      cmndText = cmndsText[idx + 1];
      stateMan(command: commands.run, mode: currentMode);
      stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    } else {
      cmndText = cmndsText.first;
      stateMan(command: commands.stop, mode: currentMode);
      stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
    }
    update();
  }

  //final triggersText = const ['None', 'Auto', 'Timer', 'Level'];
  var trigStartText = 'Auto'.obs;
  var trigStopText = 'Auto'.obs;

  bool doNotDisturb() {
    if (currentState == states.capturing ||
        currentState == states.persisting ||
        currentState == states.waiting) {
      return true;
    } else {
      return false;
    }
  }

  void handleTrigStartPressed() {
    //dont modify trigger when running
    if (doNotDisturb()) return;
    trigStartText.value = getNextTrigLabel(trigStartText.value);
  }

  void handleTrigStopPressed() {
    //dont modify trigger when running
    if (doNotDisturb()) return;
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
    if (doNotDisturb()) return;
    var idx = modesText.indexOf(modeText.value);
    if (idx < modesText.length - 1) {
      modeText.value = modesText[idx + 1];
    } else {
      modeText.value = modesText.first;
    }
    //capture
    if (modeText.value == modesText[0]) {
      stateMan(command: commands.none, mode: modes.capture);
    }
    //persist
    else if (modeText.value == modesText[1]) {
      stateMan(command: commands.none, mode: modes.persist);
    }
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
  }

  var waitForDuration = Duration(seconds: 5);
  var runUntilDuration = Duration(seconds: 10);

  enableStartTimeout() {
    print('start timer: ${DateTime.now()}');
    return Timer(waitForDuration, startTimerCallback);
  }

  void startTimerCallback() {
    print('start timer: ${DateTime.now()}');
    stateMan(command: commands.start, mode: currentMode);
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
  }

  enableStartStopTimeout() {
    print('start timer: ${DateTime.now()}');
    return Timer(runUntilDuration, startStopTimerCallback);
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
    cmndText = cmndsText.first;
    stateMan(command: commands.stop, mode: currentMode);
    stateExecute(modeChanged: modeChanged, stateChanged: stateChanged);
  }

  void sliderCallBack(
    int handlerIndex,
    dynamic lowerValue,
    dynamic upperValue,
  ) {
    print('slider- lower: $lowerValue upper: $upperValue');
    zoomMin = lowerValue as double;
    zoomMax = upperValue as double;
    update();
  }

  Future<void> handleLongPress(
    String trigText, {
    String startStopText = 'start',
  }) async {
    if (trigText == triggerType[0]) {
      Map<dynamic, dynamic> result =
          await Get.to(LevelTrigSetup(levelTrigData()));
      print(result);
      setLevelTrigData(result);
    } else if (trigText == triggerType[1]) {
      if (startStopText == 'start') {
        Duration result = await Get.to(TimingSetup(
          duration: waitForDuration,
        ));
        print('result: $result');
        waitForDuration = result;
      } else {
        Duration result = await Get.to(TimingSetup(
          duration: runUntilDuration,
        ));
        print('result: $result');
        runUntilDuration = result;
      }
    } else {
      if (startStopText == 'run') {
        Duration result = await Get.to(TimingSetup(
          duration: Duration(milliseconds: samplePeriod),
        ));
        print('result: $result');
        samplePeriod = result.inMilliseconds;
        //updating sample period does not change stream content
        //the stream needs to be restarted with the new period.
        restartStream();
      }
    }
  }

  var mqttPubBuf = <SensorModel>[];
  void mqttPublish(SensorModel aModel, bool flush) {
    mqttPubBuf.add(aModel);
    bool publishMessage = flush || mqttPubBuf.length >= mqttBufTrigLength;
    if (publishMessage) {
      mqttMan?.publish(SensorModelConvert.toJsonEncoded('1000', mqttPubBuf));
      mqttPubBuf.clear();
    }
  }
}
