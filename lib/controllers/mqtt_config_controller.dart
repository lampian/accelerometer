import 'package:accelerometer/models/mqtt_model.dart';
import 'package:accelerometer/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

enum Mode { create, read, update, delete, copy }

class MqttConfigController extends GetxController {
  var _mqttList = Rx<List<MqttModel>>();
  List<MqttModel> get mqttList => _mqttList.value;

  var _title = 'title'.obs;
  get title => this._title.value;
  set title(value) => this._title.value = value;

  var _mode = Mode.read.obs;
  get mode => this._mode.value;
  set mode(value) => this._mode.value = value;

  User _user;
  User get user => _user;
  set user(value) => this._user;

  @override
  void onInit() {
    super.onInit();
    _user = Get.find<AuthController>().currentUser;
    if (user == null) return;
    _mqttList.bindStream(Database().userMqttStream(user.uid));
  }

  void handleMode() {
    switch (mode) {
      case Mode.create:
        mode = Mode.read;
        break;
      case Mode.read:
        mode = Mode.update;
        break;
      case Mode.update:
        mode = Mode.delete;
        break;
      case Mode.delete:
        mode = Mode.copy;
        break;
      case Mode.copy:
        mode = Mode.create;
        break;
      default:
        mode = Mode.read;
    }
    title = title + '>';
    update();
  }
}
