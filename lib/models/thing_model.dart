// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class ThingModel {
  ThingModel({
    this.id = '',
    this.host = '',
    this.port = '',
    this.identifier = '',
    //this.topic = '',
    //this.willTopic = '',
    //this.willMessage = '',
    //this.qos = 0,
    this.keepAlivePeriod = 600,
    //this.isPub = false,
    this.secure = false,
    //this.logging = false,
  });
  String id = '';
  String host = '';
  String port = '';
  String identifier = '';
  //String topic = '';
  //String willTopic = '';
  //String willMessage = '';
  //int qos = 0;
  int keepAlivePeriod = 0;
  //bool isPub = false;
  bool secure = false;
  //bool logging = false;

  ThingModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot?.id ?? '';
    host = documentSnapshot?.get('host') as String;
    port = documentSnapshot?.get('port') as String;
    identifier = documentSnapshot?.get('identifier') as String;
    //topic = documentSnapshot?.get('topic') as String;
    //willTopic = documentSnapshot?.get('willTopic') as String;
    //willMessage = documentSnapshot?.get('willMessage') as String;
    //qos = documentSnapshot?.get('qos') as int;
    keepAlivePeriod = documentSnapshot?.get('keepAlivePeriod') as int;
    //isPub = documentSnapshot?.get('isPub') as bool;
    secure = documentSnapshot?.get('secure') as bool;
    //logging = documentSnapshot?.get('logging') as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['host'] = this.host;
    data['port'] = this.port;
    data['identifier'] = this.identifier;
    //data['topic'] = this.topic;
    //data['willTopic'] = this.willTopic;
    //data['willMessage'] = this.willMessage;
    //data['qos'] = this.qos;
    data['keepAlivePeriod'] = this.keepAlivePeriod;
    //data['isPub'] = this.isPub;
    data['secure'] = this.secure;
    //data['logging'] = this.logging;
    return data;
  }

  static ThingModel emptyModel() {
    return (ThingModel(
      id: '',
      host: '',
      port: '',
      identifier: '',
      //topic: '',
      //willTopic: '',
      //willMessage: '',
      //qos: 0,
      keepAlivePeriod: 0,
      //isPub: false,
      secure: false,
      //logging: false,
    ));
  }
}
