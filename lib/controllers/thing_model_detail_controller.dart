// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/models/thing_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:accelerometer/services/database.dart';

class ThingModelDetailController extends GetxController {
  TextEditingController deviceIdTEC;
  String get deviceId => this.deviceIdTEC?.text ?? '';
  set deviceId(String value) => this.deviceIdTEC?.text = value;

  TextEditingController hostTEC;
  String get host => this.hostTEC?.text ?? '';
  set host(String value) => this.hostTEC?.text = value;

  TextEditingController portTEC;
  String get port => this.portTEC?.text ?? '';
  set port(String value) => this.portTEC?.text = value;

  TextEditingController identifierTEC;
  String get identifier => this.identifierTEC?.text ?? '';
  set identifier(String value) => this.identifierTEC?.text = value;

  TextEditingController keepAliveTEC;
  String get keepAlive => this.keepAliveTEC?.text ?? '';
  set keepAlive(String value) => this.keepAliveTEC?.text = value;

  // TextEditingController qosTEC;
  // String get qos => this.qosTEC?.text ?? '';
  // set qos(String value) => this.qosTEC?.text = value;

  // TextEditingController topicTEC;
  // String get topic => this.topicTEC?.text ?? '';
  // set topic(String value) => this.topicTEC?.text = value;

  var _secure = false.obs;
  bool get secure => this._secure.value;
  set secure(bool value) => this._secure.value = value;

  var _canSave = false.obs;
  bool get canSave => this._canSave.value;
  set canSave(bool value) => this._canSave.value = value;

  String _title = '';
  String get title => this._title;
  set title(String value) => this._title = value;

  // var _isPub = false.obs;
  // bool get isPub => _isPub.value;
  // set isPub(bool value) => _isPub.value = value;
  // void isPubChanged(bool val) {
  //   if (!readOnly) isPub = val;
  //   update();
  // }

  // String willTopic = '';
  // String willMessage = '';

  //bool logging = false;
  bool readOnly = false;

  @override
  void onInit() {
    super.onInit();
    deviceIdTEC = TextEditingController();
    hostTEC = TextEditingController();
    portTEC = TextEditingController();
    identifierTEC = TextEditingController();
    keepAliveTEC = TextEditingController();
    //topicTEC = TextEditingController();
    //qosTEC = TextEditingController();
  }

  @override
  void onClose() {
    deviceIdTEC?.dispose();
    hostTEC?.dispose();
    portTEC?.dispose();
    identifierTEC?.dispose();
    keepAliveTEC?.dispose();
    //qosTEC?.dispose();
    super.onClose();
  }

  void updateModel(ThingModel thingModel) {
    deviceId = thingModel.id;
    host = thingModel.host;
    port = thingModel.port;
    identifier = thingModel.identifier;
    keepAlive = thingModel.keepAlivePeriod.toString();
    //topic = mqttModel.topic;
    //qos = mqttModel.qos.toString();
    //isPub = mqttModel.isPub;
    secure = thingModel.secure;
    //logging = mqttModel.logging;
    //willTopic = mqttModel.willTopic;
    //willMessage = mqttModel.willMessage;
    update();
  }

  bool validateMqttData() {
    if (readOnly) return false;
    if (deviceIdTEC?.value?.isNullOrBlank ?? true) return false;
    if (identifierTEC?.value?.isNullOrBlank ?? true) return false;
    if (hostTEC?.value?.isNullOrBlank ?? true) return false;
    //if (topicTEC?.value?.isNullOrBlank ?? true) return false;
    port = portTEC?.value?.isNullOrBlank ?? true ? '100' : port;
    keepAlive = keepAliveTEC?.value?.isNullOrBlank ?? true ? '10' : keepAlive;
    //qos = qosTEC?.value?.isNullOrBlank ?? true ? '3' : qos;
    //isPub = isPub.isNullOrBlank ? true : isPub;
    secure = _secure.isNullOrBlank ? true : secure;
    //logging = logging.isNullOrBlank ? false : logging;
    //willTopic = '';
    //willMessage = '';
    return true;
  }

  ThingModel buildModel() {
    return ThingModel(
      host: host,
      id: deviceId,
      identifier: identifier,
      //isPub: isPub,
      keepAlivePeriod: int.parse(keepAlive),
      //logging: logging,
      port: port,
      //qos: int.parse(qos),
      secure: secure,
      //topic: topic,
      //willMessage: willMessage,
      //willTopic: willTopic,
    );
  }

  //this operation saves to firebase
  // saving to local storage is done in mqttcoonfig device write
  Future<bool> saveMqtt() async {
    if (validateMqttData()) {
      if (!readOnly) {
        var user = Get.find<AuthController>().user;
        if (await Database().updateThingAtUser(user.uid, buildModel())) {
          if (await Database().updateThing(buildModel())) {
            return true;
          }
          print('app: saveMqtt save to things failed');
          return false;
        }
        print('app: saveMqtt save to user failed');
        return false;
      }
      print('app: saveMqtt data readonly check failed');
      return true;
    }
    print('app: saveMqtt data validation failed');
    return false;
  }
}
