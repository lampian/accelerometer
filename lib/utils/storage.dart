// @dart=2.9
import 'dart:convert';

import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/models/thing_model.dart';
import 'package:get_storage/get_storage.dart';

class Storage {
  static void storeMqttModel(ThingModel aModel) {
    final box = GetStorage();
    var aStr = jsonEncode(aModel);
    box.write('device', aStr);
  }

  static ThingModel retrieveMqttModel() {
    final box = GetStorage();
    String aVal = box.read('device').toString();
    try {
      var aMap = jsonDecode(aVal);
      return ThingModel.fromJson(aMap as Map<String, dynamic>);
    } catch (e) {
      ThingModel.emptyModel();
    }
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
    var aStr = jsonEncode(aModel);
    box.write('channel', aStr);
  }

  static ChannelModel retrieveChannelModel() {
    final box = GetStorage();
    String aVal = box.read('channel').toString();
    try {
      var aMap = jsonDecode(aVal);
      return ChannelModel.fromJson(aMap as Map<String, dynamic>);
    } catch (e) {
      return ChannelModel.emptyModel();
    }
  }

  static String cleanMapValue(String val) {
    var aStr = val.replaceAll('(', '');
    aStr = aStr.replaceAll(')', '');
    aStr = aStr.replaceAll(' ', '');
    return aStr;
  }
}
