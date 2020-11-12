import 'package:get/get.dart';

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
  @override
  void onInit() {
    super.onInit();
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
}
