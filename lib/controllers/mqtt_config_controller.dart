import 'dart:async';

import 'package:accelerometer/models/mqtt_model.dart';
import 'package:accelerometer/services/database.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/views/mqtt_model_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

enum Mode { create, read, update, delete, copy, configure, test }

class MqttConfigController extends GetxController {
  final _mqttList = Rx<List<MqttModel>>();
  List<MqttModel> get mqttList => _mqttList.value;

  final _title = 'title'.obs;
  get title => this._title.value;
  set title(value) => this._title.value = value;

  final _mode = Mode.read.obs;
  get mode => this._mode.value;
  set mode(value) => this._mode.value = value;

  User _user;
  User get user => _user;
  set user(value) => this._user;

  MqttManager mqttManager;

  @override
  Future<void> onInit() async {
    super.onInit();
    _user = Get.find<AuthController>().currentUser;
    if (user == null) {
      print('mqtt config controller user is null during init');
      return;
    }
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
        mode = Mode.configure;
        break;
      case Mode.configure:
        mode = Mode.test;
        break;
      case Mode.test:
        mode = Mode.create;
        break;

      default:
        mode = Mode.read;
    }
    title = title + '>';
    update();
  }

  void editDetail(MqttModel model, bool readOnly) {
    Get.to(MqttModelDetail(model, readOnly));
    update();
  }

  Future<bool> removeItem(MqttModel mqttMdoel) async {
    var user = Get.find<AuthController>().user;
    if (await Database().deleteMqttAtUser(user.uid, mqttMdoel)) {
      mode = Mode.read;
      return true;
    }
    return false;
  }

  MqttModel getEmptyModel(String id) {
    return MqttModel(
        id: id,
        host: '',
        identifier: '',
        isPub: false,
        keepAlivePeriod: 60,
        logging: false,
        port: '443',
        qos: 0,
        secure: true,
        topic: '',
        willMessage: '',
        willTopic: '');
  }
}
