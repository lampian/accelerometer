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

  final _title = 'IoT device'.obs;
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

  void handleMode(String retStr) {
    switch (retStr) {
      case 'New':
        mode = Mode.create;
        var emptyModel = ThingModel.emptyModel();
        emptyModel.id = 'fix id ';
        editDetail(emptyModel, false);
        mode = Mode.read;
        break;
      case 'View':
        mode = Mode.read;
        break;
      case 'Edit':
        mode = Mode.update;
        break;
      case 'Delete':
        mode = Mode.delete;
        break;
      case 'Copy':
        mode = Mode.copy;
        break;
      case 'Configure':
        mode = Mode.configure;
        break;
      case 'Test':
        mode = Mode.test;
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
