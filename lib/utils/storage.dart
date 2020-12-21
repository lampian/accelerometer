// @dart=2.9
import 'package:accelerometer/models/mqtt_model.dart';
import 'package:get_storage/get_storage.dart';

class Storage {
  static void storeMqttModel(MqttModel aModel) {
    final box = GetStorage();
    //box.erase();
    box.write('id', aModel.id);
    box.write('host', aModel.host);
    box.write('port', aModel.port);
    box.write('identifier', aModel.identifier);
    box.write('topic', aModel.topic);
    box.write('willTopic', aModel.willTopic);
    box.write('willMessage', aModel.willMessage);
    box.write('qos', aModel.qos);
    box.write('keepAlivePeriod', aModel.keepAlivePeriod);
    box.write('isPub', aModel.isPub);
    box.write('secure', aModel.secure);
    box.write('logging', aModel.logging);
  }

  static MqttModel retrieveMqttModel() {
    final box = GetStorage();
    return MqttModel(
      id: box.read('id'),
      host: box.read('host'),
      port: box.read('port'),
      identifier: box.read('identifier'),
      topic: box.read('topic'),
      willTopic: box.read('willTopic'),
      willMessage: box.read('willMessage'),
      qos: box.read('qos'),
      keepAlivePeriod: box.read('keepAlivePeriod'),
      isPub: box.read('isPub'),
      secure: box.read('secure'),
      logging: box.read('logging'),
    );
  }
}
