import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  bool admin;
  bool verified;

  UserModel({this.id, this.name, this.email, this.admin, this.verified});

  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot.get('name');
    email = documentSnapshot.get('email');
    admin = documentSnapshot.get('admin');
    verified = documentSnapshot.get('verified');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['admin'] = this.admin;
    data['verified'] = this.verified;
    return data;
  }
}
