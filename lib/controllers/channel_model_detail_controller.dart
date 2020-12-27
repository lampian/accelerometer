// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';

//enum Modes { none, add, edit, remove }

class ChannelModelDetailController extends GetxController {
  TextEditingController deviceIdTEC;
  String get deviceId => this.deviceIdTEC.text;
  set deviceId(String value) => this.deviceIdTEC.text = value;

  TextEditingController channelIdTEC;
  String get channelId => this.channelIdTEC.text;
  set channelId(String value) => this.channelIdTEC.text = value;

  TextEditingController descriptionTEC;
  String get description => this.descriptionTEC.text;
  set description(String value) => this.descriptionTEC.text = value;

  TextEditingController topicTEC;
  String get topic => this.topicTEC.text;
  set topic(String value) => this.topicTEC.text = value;

  TextEditingController pubTEC;
  String get pub => this.pubTEC.text;
  set pub(String value) => this.pubTEC.text = value;

  TextEditingController subTEC;
  String get sub => this.subTEC.text;
  set sub(String value) => this.subTEC.text = value;

  TextEditingController durationTEC;
  String get duration => this.durationTEC.text;
  set duration(String value) => this.durationTEC.text = value;

  TextEditingController sampleRateTEC;
  String get sampleRate => this.sampleRateTEC.text;
  set sampleRate(String value) => this.sampleRateTEC.text = value;

  TextEditingController trigStartTEC;
  String get trigStart => this.trigStartTEC.text;
  set trigStart(String value) => this.trigStartTEC.text = value;

  TextEditingController trigStopTEC;
  String get trigStop => this.trigStopTEC.text;
  set trigStop(String value) => this.trigStopTEC.text = value;

  TextEditingController trigSourceTEC;
  String get trigSource => this.trigSourceTEC.text;
  set trigSource(String value) => this.trigSourceTEC.text = value;

  TextEditingController qosTEC;
  String get qos => this.qosTEC.text;
  set qos(String value) => this.qosTEC.text = value;

  TextEditingController ioTypeTEC;
  String get ioType => this.ioTypeTEC.text;
  set ioType(String value) => this.ioTypeTEC.text = value;

  TextEditingController ioInitTEC;
  String get ioInit => this.ioInitTEC.text;
  set ioInit(String value) => this.ioInitTEC.text = value;

  var _onChangeUpdate = false.obs;
  bool get onChangeUpdate => this._onChangeUpdate.value;
  set onChangeUpdate(bool value) => this._onChangeUpdate.value = value;

  var _readOnly = false.obs;
  bool get readOnly => this._readOnly.value;
  set readOnly(bool value) => this._readOnly.value = value;

  String _title;
  String get title => this._title;
  set title(String value) => this._title = value;

  ChannelModel theChannel;
  User user;

  void Initialise(bool readOnlyP, ChannelModel channelModel) {
    readOnly = readOnlyP;
    theChannel = channelModel ?? ChannelModel.emptyModel();
    if (readOnly) {
      deviceId = '';
      title = 'View channel';
    } else {
      deviceId = theChannel.channelID;
      title = 'Edit channel';
    }

    deviceId = theChannel.deviceID;
    channelId = theChannel.channelID;
    description = theChannel.description;
    topic = theChannel.topic;
    pub = theChannel.pub;
    sub = theChannel.sub;
    duration = theChannel.duration;
    sampleRate = theChannel.sampleRate;
    trigStart = theChannel.trigStart;
    trigStop = theChannel.trigStop;
    trigSource = theChannel.trigSource;
    qos = theChannel.qos;
    onChangeUpdate = theChannel.onChangeUpdate;
    ioType = theChannel.ioType;
    ioInit = theChannel.ioInit;
  }

  @override
  void onInit() {
    deviceIdTEC = TextEditingController();
    channelIdTEC = TextEditingController();
    descriptionTEC = TextEditingController();
    topicTEC = TextEditingController();
    pubTEC = TextEditingController();
    subTEC = TextEditingController();
    durationTEC = TextEditingController();
    sampleRateTEC = TextEditingController();
    trigStartTEC = TextEditingController();
    trigStopTEC = TextEditingController();
    trigSourceTEC = TextEditingController();
    qosTEC = TextEditingController();
    ioInitTEC = TextEditingController();
    ioTypeTEC = TextEditingController();
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    deviceIdTEC?.dispose();
    channelIdTEC?.dispose();
    descriptionTEC?.dispose();
    topicTEC?.dispose();
    pubTEC?.dispose();
    subTEC?.dispose();
    durationTEC?.dispose();
    sampleRateTEC?.dispose();
    trigStartTEC?.dispose();
    trigStopTEC?.dispose();
    trigSourceTEC?.dispose();
    qosTEC?.dispose();
    ioTypeTEC?.dispose();
    ioInitTEC?.dispose();
    super.onClose();
  }

  Future<bool> saveChannel() async {
    if (!readOnly) {
      if (deviceId.isEmpty) {
        final Guid aGUID = Guid.newGuid;
        deviceId = aGUID.value;
      }

      ChannelModel aC = buildChannel();
      if (await Database().editChannelAtUser(user.uid, aC)) {
        if (await Database().editChannel(aC)) {
          return true;
        }
        print('app: saveChannel - firestore things save error');
        return false;
      }
      print('app: saveChannel - firestore user things save error');

      return false;
    } else {
      print('app: saveChannel -readonly error');
      return false;
    }
  }

  ChannelModel buildChannel() {
    return ChannelModel(
        deviceID: deviceId,
        channelID: channelId,
        description: description,
        topic: topic,
        pub: pub,
        sub: sub,
        duration: duration,
        sampleRate: sampleRate,
        trigStart: trigStart,
        trigStop: trigStop,
        trigSource: trigSource,
        qos: qos,
        onChangeUpdate: onChangeUpdate,
        ioInit: ioInit,
        ioType: ioType);
  }

  void setUser() {
    user = Get.find<AuthController>().user;
  }
}
