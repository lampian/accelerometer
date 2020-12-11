import 'package:cloud_firestore/cloud_firestore.dart';

class MqttModel {
  String id;
  String host;
  String port;
  String identifier;
  String topic;
  String willTopic;
  String willMessage;
  int qos;
  int keepAlivePeriod;
  bool isPub;
  bool secure;
  bool logging;

  MqttModel({
    this.id,
    this.host,
    this.port,
    this.identifier,
    this.topic,
    this.willTopic,
    this.willMessage,
    this.qos,
    this.keepAlivePeriod,
    this.isPub,
    this.secure,
    this.logging,
  });

  MqttModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    host = documentSnapshot.get('host');
    port = documentSnapshot.get('port');
    identifier = documentSnapshot.get('identifier');
    topic = documentSnapshot.get('topic');
    willTopic = documentSnapshot.get('willTopic');
    willMessage = documentSnapshot.get('willMessage');
    qos = documentSnapshot.get('qos');
    keepAlivePeriod = documentSnapshot.get('keepAlivePeriod');
    isPub = documentSnapshot.get('isPub');
    secure = documentSnapshot.get('secure');
    logging = documentSnapshot.get('logging');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['host'] = this.host;
    data['port'] = this.port;
    data['identifier'] = this.identifier;
    data['topic'] = this.topic;
    data['willTopic'] = this.willTopic;
    data['willMessage'] = this.willMessage;
    data['qos'] = this.qos;
    data['keepAlivePeriod'] = this.keepAlivePeriod;
    data['isPub'] = this.isPub;
    data['secure'] = this.secure;
    data['logging'] = this.logging;
    return data;
  }
}
