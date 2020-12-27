// @dart=2.9
import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/models/thing_model.dart';
import 'package:get_storage/get_storage.dart';

class Storage {
  static void storeMqttModel(ThingModel aModel) {
    final box = GetStorage();
    //box.erase();
    box.write('id', aModel.id);
    box.write('host', aModel.host);
    box.write('port', aModel.port);
    box.write('identifier', aModel.identifier);
    box.write('keepAlivePeriod', aModel.keepAlivePeriod);
    box.write('secure', aModel.secure);
  }

  static ThingModel retrieveMqttModel() {
    final box = GetStorage();
    return ThingModel(
      id: box.read('id'),
      host: box.read('host'),
      port: box.read('port'),
      identifier: box.read('identifier'),
      keepAlivePeriod: box.read('keepAlivePeriod'),
      secure: box.read('secure'),
    );
  }

  static void storeChannelModel(ChannelModel aModel) {
    final box = GetStorage();
    //box.erase();
    box.write('channelID', aModel.channelID);
    box.write('description', aModel.description);
    box.write('deviceID', aModel.deviceID);
    box.write('duration', aModel.duration);
    box.write('ioInit', aModel.ioInit);
    box.write('ioType', aModel.ioType);
    box.write('onChangeUpdate', aModel.onChangeUpdate);
    box.write('pub', aModel.pub);
    box.write('qos', aModel.qos);
    box.write('sampleRate', aModel.sampleRate);
    box.write('sub', aModel.sub);
    box.write('topic', aModel.topic);
    box.write('trigSource', aModel.trigSource);
    box.write('trigStart', aModel.trigStart);
    box.write('trigStop', aModel.trigStop);
  }

  static ChannelModel retrieveChannelModel() {
    final box = GetStorage();
    return ChannelModel(
      channelID: box.read('channelID'),
      description: box.read('description'),
      deviceID: box.read('deviceID'),
      duration: box.read('duration'),
      ioInit: box.read('ioInit'),
      ioType: box.read('ioType'),
      onChangeUpdate: box.read('onChangeUpdate'),
      pub: box.read('pub'),
      qos: box.read('qos'),
      sampleRate: box.read('sampleRate'),
      sub: box.read('sub'),
      topic: box.read('topic'),
      trigSource: box.read('trigSource'),
      trigStart: box.read('trigStart'),
      trigStop: box.read('trigStop'),
    );
  }
}
