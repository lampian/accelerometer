// @dart=2.9
import 'dart:async';

import 'package:accelerometer/models/thing_model.dart';
import 'package:accelerometer/services/database.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/views/thing_model_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

enum Mode { create, read, update, delete, copy, configure, test }

class ThingConfigController extends GetxController {
  final _thingList = Rx<List<ThingModel>>();
  List<ThingModel> get thingList => _thingList.value;

  final _title = 'title'.obs;
  String get title => this._title.value;
  set title(String value) => this._title.value = value;

  final _mode = Mode.read.obs;
  Mode get mode => this._mode.value;
  set mode(Mode value) => this._mode.value = value;

  User _user;
  User get user => _user;
  set user(value) => this._user;

  MqttManager mqttManager = MqttManager();

  @override
  Future<void> onInit() async {
    super.onInit();
    _user = Get.find<AuthController>().currentUser;
    if (user?.email == '') {
      print('app: thing config controller user is empty during init');
      return;
    }
    _thingList.bindStream(Database().userThingStream(user?.uid ?? ''));
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

  void editDetail(ThingModel thingModel, bool readOnly) {
    Get.to(ThingModelDetail(thingModel, readOnly));
    //update();
  }

  Future<bool> removeItem(ThingModel thingModel) async {
    var user = Get.find<AuthController>().user;
    if (await Database().deleteThingAtUser(user.uid, thingModel)) {
      if (await Database().deleteThing(thingModel)) {
        mode = Mode.read;
        return true;
      }
      return false;
    }
    return false;
  }
}
