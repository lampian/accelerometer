import 'package:accelerometer/models/mqtt_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MqttModelDetailController extends GetxController {
  TextEditingController idTEC;
  get id => this.idTEC.text;
  set id(String value) => this.idTEC.text = value;

  TextEditingController hostTEC;
  get host => this.hostTEC.text;
  set host(String value) => this.hostTEC.text = value;

  TextEditingController portTEC;
  get port => this.portTEC.text;
  set port(String value) => this.portTEC.text = value;

  TextEditingController identifierTEC;
  get identifier => this.identifierTEC.text;
  set identifier(String value) => this.identifierTEC.text = value;

  TextEditingController keepAliveTEC;
  get keepAlive => this.keepAliveTEC.text;
  set keepAlive(String value) => this.keepAliveTEC.text = value;

  TextEditingController qosTEC;
  get qos => this.qosTEC.text;
  set qos(String value) => this.qosTEC.text = value;

  TextEditingController topicTEC;
  get topic => this.topicTEC.text;
  set topic(String value) => this.topicTEC.text = value;

  var _secure = false.obs;
  get secure => this._secure.value;
  set secure(value) => this._secure.value = value;

  var _canSave = false.obs;
  get canSave => this._canSave.value;
  set canSave(value) => this._canSave.value = value;

  String _title;
  get title => this._title;
  set title(value) => this._title = value;

  var _isPub = false.obs;
  bool get isPub => _isPub.value;
  set isPub(value) => _isPub.value = value;
  void isPubChanged(bool val) {
    if (!readOnly) isPub = val;
    update();
  }

  String willTopic;
  String willMessage;

  bool logging;
  bool readOnly;

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
}
