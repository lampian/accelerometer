// @dart=2.9
import 'dart:convert';

import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/utils/storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum Modes { create, view, edit, delete, deleteAll }

class StorageManagerController extends GetxController {
  final _mode = Modes.view.obs;
  Modes get mode => _mode.value;
  set mode(Modes value) => _mode.value = value;

  final _items = Rx<List<Map<String, String>>>();
  List<Map<String, String>> get items => _items.value;
  set items(List<Map<String, String>> value) => _items.value = value;

  GetStorage bucket;

  void onInit() {
    super.onInit();
  }

  String getKey(int index) {
    return Storage.cleanMapValue(items[index].keys.toString());
  }

  String getValue(int index) {
    return Storage.cleanMapValue(items[index].values.toString());
  }

  void InitController() {
    bucket = GetStorage();
    items = buildItemList();
  }

  List<Map<String, String>> buildItemList() {
    List<Map<String, String>> mapList = [];
    bucket.save();
    var keys = bucket.getKeys().toString();
    print('app: $keys');
    keys = Storage.cleanMapValue(keys);
    if (keys.isEmpty) {
      return mapList;
    }
    var strList = keys.split(',');
    strList.forEach((element) {
      print('app: storage values: $element-${bucket.read(element)}');
      if (element == 'channel') {
        var aChan = Storage.retrieveChannelModel();
        Map<String, String> map;
        map = {'channelID': aChan.channelID};
        mapList.add(map);
        map = {'description': aChan.description};
        mapList.add(map);
        map = {'deviceID': aChan.deviceID};
        mapList.add(map);
        map = {'duration': aChan.duration};
        mapList.add(map);
        map = {'ioInit': aChan.ioInit};
        mapList.add(map);
        map = {'ioType': aChan.ioType};
        mapList.add(map);
        map = {'pub': aChan.pub};
        mapList.add(map);
        map = {'qos': aChan.qos};
        mapList.add(map);
        map = {'sampleRate': aChan.sampleRate};
        mapList.add(map);
        map = {'sub': aChan.sub};
        mapList.add(map);
        map = {'topic': aChan.topic};
        mapList.add(map);
        map = {'trigSource': aChan.trigSource};
        mapList.add(map);
        map = {'trigStart': aChan.trigStart};
        mapList.add(map);
        map = {'trigStop': aChan.trigStop};
        mapList.add(map);
      } else if (element == 'device') {
        var aThing = Storage.retrieveMqttModel();
        Map<String, String> map;
        map = {'host': aThing.host};
        mapList.add(map);
        map = {'id': aThing.id};
        mapList.add(map);
        map = {'identifier': aThing.identifier};
        mapList.add(map);
        map = {'port': aThing.port};
        mapList.add(map);
        map = {'keep AlivePeriod': aThing.keepAlivePeriod.toString()};
        mapList.add(map);
        map = {'secure': aThing.secure.toString()};
        mapList.add(map);
      } else {
        var value = bucket.read(element).toString();
        Map<String, String> map = {element: value};
        mapList.add(map);
      }
    });
    return mapList;
  }
}
