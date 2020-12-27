// @dart=2.9
import 'dart:async';

import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/services/database.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/views/channel_model_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

enum ChanMode { create, read, update, delete, copy, test }

class ChannelConfigController extends GetxController {
  final _channelList = Rx<List<ChannelModel>>();
  List<ChannelModel> get channelList => _channelList.value;

  final _title = 'title'.obs;
  String get title => this._title.value;
  set title(String value) => this._title.value = value;

  final _mode = ChanMode.read.obs;
  ChanMode get mode => this._mode.value;
  set mode(ChanMode value) => this._mode.value = value;

  User _user;
  User get user => _user;
  set user(value) => this._user;

  MqttManager mqttManager = MqttManager();

  // @override
  // Future<void> onInit() async {
  //   super.onInit();
  // }

  String _deviceId = '';
  String get deviceId => _deviceId;
  set deviceId(String value) => _deviceId = value;

  String _userId = '';
  String get userId => _userId;
  set userId(String value) => _userId = value;

  void Initialise(String uId, String deviceIdPar) {
    deviceId = deviceIdPar;
    userId = uId;
    title = deviceId;
    _channelList.bindStream(Database().channelStreamFromUser(userId, deviceId));
  }

  void handleMode() {
    switch (mode) {
      case ChanMode.create:
        mode = ChanMode.read;
        break;
      case ChanMode.read:
        mode = ChanMode.update;
        break;
      case ChanMode.update:
        mode = ChanMode.delete;
        break;
      case ChanMode.delete:
        mode = ChanMode.copy;
        break;
      case ChanMode.copy:
        mode = ChanMode.test;
        break;
      case ChanMode.test:
        mode = ChanMode.create;
        break;

      default:
        mode = ChanMode.read;
    }
    title = title + '>';
    update();
  }

  void editDetail(ChannelModel model, bool readOnly) {
    Get.to(ChannelModelDetail(
      readOnly: readOnly,
      channelModel: model,
    )); //model, readOnly));
    update();
  }

  Future<bool> removeItem(ChannelModel channelModel) async {
    var user = Get.find<AuthController>().user;
    if (await Database().deleteChannelAtUser(user.uid, channelModel)) {
      if (await Database().deleteChannel(channelModel)) {
        mode = ChanMode.read;
        return true;
      }
      return false;
    }
    return false;
  }
}
