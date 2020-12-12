import 'dart:io';

import 'package:accelerometer/certificate/keys.dart';
import 'package:accelerometer/models/mqtt_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MqttController extends GetxController {
  String _host;
  String get host => _host;
  set host(val) => _host = val;

  String _identifier;
  String get identifier => _identifier;
  set identidfier(val) => _identifier = val;

  String _topic;
  String get topic => _topic;
  set topic(val) => _topic = val;

  var _history = '';
  String get history => _history;
  set history(val) => _history = val;

  var _received = '';
  String get received => _received;
  set received(value) {
    _received = value;
    history = history + '\n' + received;
  }

  var _lastRxTopic = 'no topic available';
  String get lastRxTopic => _lastRxTopic;
  set lastRxTopic(val) => _lastRxTopic = val;

  var _lastRxMsg = 'no message available';
  String get lastRxMsg => this._lastRxMsg;
  set lastRxMsg(val) => this._lastRxMsg = val;

  var _appConnectionState = MQTTAppConnectionState.disconnected;
  MQTTAppConnectionState get appConnectionState => _appConnectionState;
  set appConnectionState(val) => _appConnectionState = val;

  var _mqttModel = MqttModel();
  MqttModel get mqttModel => _mqttModel;
  set mqttModel(value) {
    this._mqttModel = value;
    host = _mqttModel.host;
    topic = _mqttModel.topic;
  }

  String rsaPrivateFilePathandName;
  String get rsaFile => rsaPrivateFilePathandName;

  @override
  void onInit() {
    writePrivateKey(rsaPrivateKey);
    super.onInit();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    rsaPrivateFilePathandName = path + '/rsa_private.pem';
    return File(rsaPrivateFilePathandName);
  }

  Future<File> writePrivateKey(String aKey) async {
    final file = await _localFile;

    // Write the file.
    return null;
    //file.writeAsString(aKey);
  }
}
