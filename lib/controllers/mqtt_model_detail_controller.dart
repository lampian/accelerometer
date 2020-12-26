// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/models/thing.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:accelerometer/services/database.dart';

class MqttModelDetailController extends GetxController {
  TextEditingController idTEC;
  String get id => this.idTEC?.text ?? '';
  set id(String value) => this.idTEC?.text = value;

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

  TextEditingController qosTEC;
  String get qos => this.qosTEC?.text ?? '';
  set qos(String value) => this.qosTEC?.text = value;

  TextEditingController topicTEC;
  String get topic => this.topicTEC?.text ?? '';
  set topic(String value) => this.topicTEC?.text = value;

  var _secure = false.obs;
  bool get secure => this._secure.value;
  set secure(bool value) => this._secure.value = value;

  var _canSave = false.obs;
  bool get canSave => this._canSave.value;
  set canSave(bool value) => this._canSave.value = value;

  String _title = '';
  String get title => this._title;
  set title(String value) => this._title = value;

  var _isPub = false.obs;
  bool get isPub => _isPub.value;
  set isPub(bool value) => _isPub.value = value;
  void isPubChanged(bool val) {
    if (!readOnly) isPub = val;
    update();
  }

  String willTopic = '';
  String willMessage = '';

  bool logging = false;
  bool readOnly = false;

  @override
  void onInit() {
    super.onInit();
    idTEC = TextEditingController();
    hostTEC = TextEditingController();
    portTEC = TextEditingController();
    identifierTEC = TextEditingController();
    keepAliveTEC = TextEditingController();
    topicTEC = TextEditingController();
    qosTEC = TextEditingController();
  }

  @override
  void onClose() {
    idTEC?.dispose();
    hostTEC?.dispose();
    portTEC?.dispose();
    identifierTEC?.dispose();
    keepAliveTEC?.dispose();
    qosTEC?.dispose();
    super.onClose();
  }

  void updateModel(MqttModel mqttModel) {
    id = mqttModel.id;
    host = mqttModel.host;
    port = mqttModel.port;
    identifier = mqttModel.identifier;
    keepAlive = mqttModel.keepAlivePeriod.toString();
    topic = mqttModel.topic;
    qos = mqttModel.qos.toString();
    isPub = mqttModel.isPub;
    secure = mqttModel.secure;
    logging = mqttModel.logging;
    willTopic = mqttModel.willTopic;
    willMessage = mqttModel.willMessage;
    update();
  }

  bool validateMqttData() {
    if (readOnly) return false;
    if (idTEC?.value?.isNullOrBlank ?? true) return false;
    if (identifierTEC?.value?.isNullOrBlank ?? true) return false;
    if (hostTEC?.value?.isNullOrBlank ?? true) return false;
    if (topicTEC?.value?.isNullOrBlank ?? true) return false;
    port = portTEC?.value?.isNullOrBlank ?? true ? '100' : port;
    keepAlive = keepAliveTEC?.value?.isNullOrBlank ?? true ? '10' : keepAlive;
    qos = qosTEC?.value?.isNullOrBlank ?? true ? '3' : qos;
    isPub = isPub.isNullOrBlank ? true : isPub;
    secure = _secure.isNullOrBlank ? true : secure;
    logging = logging.isNullOrBlank ? false : logging;
    willTopic = '';
    willMessage = '';
    return true;
  }

  MqttModel buildModel() {
    return MqttModel(
      host: host,
      id: id,
      identifier: identifier,
      isPub: isPub,
      keepAlivePeriod: int.parse(keepAlive),
      logging: logging,
      port: port,
      qos: int.parse(qos),
      secure: secure,
      topic: topic,
      willMessage: willMessage,
      willTopic: willTopic,
    );
  }

  //this operation saves to firebase
  // saving to local storage is done in mqttcoonfig device write
  Future<bool> saveMqtt() async {
    if (validateMqttData()) {
      if (!readOnly) {
        var user = Get.find<AuthController>().user;
        if (await Database().updateMqttAtUser(user.uid, buildModel())) {
          return true;
        }
        return false;
      }
      return true;
    }
    return false;
  }
}
