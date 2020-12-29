// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  ChannelModel(
      {this.deviceID,
      this.channelID,
      this.description,
      this.topic,
      this.pub,
      this.sub,
      this.duration,
      this.sampleRate,
      this.trigStart,
      this.trigStop,
      this.trigSource,
      this.qos,
      this.onChangeUpdate,
      this.ioType,
      this.ioInit});

  String deviceID = '';
  String channelID = '';
  String description = '';
  String topic = '';
  String pub = '';
  String sub = '';
  String duration = '';
  String sampleRate = '';
  String trigStart = '';
  String trigStop = '';
  String trigSource = '';
  String ioType = '';
  String ioInit = '';
  String qos = '';
  bool onChangeUpdate = false;

  ChannelModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    deviceID = documentSnapshot.get('deviceID') as String;
    channelID = documentSnapshot.id;
    description = documentSnapshot.get('description') as String;
    topic = documentSnapshot.get('topic') as String;
    pub = documentSnapshot.get('pub') as String;
    sub = documentSnapshot.get('sub') as String;
    duration = documentSnapshot.get('duration') as String;
    sampleRate = documentSnapshot.get('sampleRate') as String;
    trigStart = documentSnapshot.get('trigStart') as String;
    trigStop = documentSnapshot.get('trigStop') as String;
    trigSource = documentSnapshot.get('trigSource') as String;
    qos = documentSnapshot.get('qos') as String;
    onChangeUpdate = documentSnapshot.get('onChangeUpdate') as bool;
    ioType = documentSnapshot.get('ioType') as String;
    ioInit = documentSnapshot.get('ioInit') as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['deviceID'] = this.deviceID;
    data['channelID'] = this.channelID;
    data['description'] = this.description;
    data['topic'] = this.topic;
    data['pub'] = this.pub;
    data['sub'] = this.sub;
    data['duration'] = this.duration;
    data['sampleRate'] = this.sampleRate;
    data['trigStart'] = this.trigStart;
    data['trigStop'] = this.trigStop;
    data['trigSource'] = this.trigSource;
    data['qos'] = this.qos;
    data['onChangeUpdate'] = this.onChangeUpdate;
    data['ioType'] = this.ioType;
    data['ioInit'] = this.ioInit;
    return data;
  }

  static ChannelModel emptyModel() {
    return ChannelModel(
      deviceID: '',
      channelID: '',
      description: '',
      topic: '',
      pub: '',
      sub: '',
      duration: '',
      sampleRate: '',
      trigStart: '',
      trigStop: '',
      trigSource: '',
      ioType: '',
      ioInit: '',
      qos: '',
      onChangeUpdate: false,
    );
  }
}
