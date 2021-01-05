// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';

class ThingModel {
  ThingModel({
    this.id = '',
    this.host = '',
    this.port = '',
    this.identifier = '',
    this.keepAlivePeriod = 600,
    this.secure = false,
  });
  String id = '';
  String host = '';
  String port = '';
  String identifier = '';
  int keepAlivePeriod = 0;
  bool secure = false;

  ThingModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot?.id ?? '';
    host = documentSnapshot?.get('host') as String;
    port = documentSnapshot?.get('port') as String;
    identifier = documentSnapshot?.get('identifier') as String;
    keepAlivePeriod = documentSnapshot?.get('keepAlivePeriod') as int;
    secure = documentSnapshot?.get('secure') as bool;
  }

  ThingModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        host = json['host'] as String,
        identifier = json['identifier'] as String,
        keepAlivePeriod = json['keepAlivePeriod'] as int,
        port = json['port'] as String,
        secure = json['secure'] as bool;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['host'] = this.host;
    data['port'] = this.port;
    data['identifier'] = this.identifier;
    data['keepAlivePeriod'] = this.keepAlivePeriod;
    data['secure'] = this.secure;
    return data;
  }

  static ThingModel emptyModel() {
    return (ThingModel(
      id: '',
      host: '',
      port: '',
      identifier: '',
      keepAlivePeriod: 0,
      secure: false,
    ));
  }
}
