// @dart=2.9
import 'dart:convert';

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
    //box.save();
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
    var aStr = aModel.toJson();
    box.write('channel', aStr);
    //box.erase();
    // box.write('channelID', aModel.channelID);
    // box.write('description', aModel.description);
    // box.write('deviceID', aModel.deviceID);
    // box.write('duration', aModel.duration);
    // box.write('ioInit', aModel.ioInit);
    // box.write('ioType', aModel.ioType);
    // box.write('onChangeUpdate', aModel.onChangeUpdate.toString());
    // box.write('pub', aModel.pub);
    // box.write('qos', aModel.qos);
    // box.write('sampleRate', aModel.sampleRate);
    // box.write('sub', aModel.sub);
    // box.write('topic', aModel.topic);
    // box.write('trigSource', aModel.trigSource);
    // box.write('trigStart', aModel.trigStart);
    // box.write('trigStop', aModel.trigStop);
    //box.save();
  }

  static ChannelModel retrieveChannelModel() {
    final box = GetStorage();
    String aStr = box.read('channel').toString();
    var aMap = jsonDecode(aStr);

    return ChannelModel(
      channelID: aMap['channelID'] as String,
      description: aMap['description'] as String,
      deviceID: aMap['deviceID'] as String,
      duration: aMap['duration'] as String,
      ioInit: aMap['ioInit'] as String,
      ioType: aMap['ioType'] as String,
      onChangeUpdate: aMap['onChangeUpdate'] as bool,
      pub: aMap['pub'] as String,
      qos: aMap['qos'] as String,
      sampleRate: aMap['sampleRate'] as String,
      sub: aMap['sub'] as String,
      topic: aMap['topic'] as String,
      trigSource: aMap['trigSource'] as String,
      trigStart: aMap['trigStart'] as String,
      trigStop: aMap['trigStop'] as String,
    );
  }

  static String cleanMapValue(String val) {
    var aStr = val.replaceAll('(', '');
    aStr = aStr.replaceAll(')', '');
    aStr = aStr.replaceAll(' ', '');
    return aStr;
  }
}
