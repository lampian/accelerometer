// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  UserModel({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.admin,
    @required this.verified,
  });
  String id = '';
  String name = '';
  String email = '';
  bool admin = false;
  bool verified = false;

  UserModel.fromDocumentSnapshot(
      {@required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot?.id;
    name = documentSnapshot?.get('name') as String;
    email = documentSnapshot?.get('email') as String;
    admin = documentSnapshot?.get('admin') as bool;
    verified = documentSnapshot?.get('verified') as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['admin'] = this.admin;
    data['verified'] = this.verified;
    return data;
  }
}
