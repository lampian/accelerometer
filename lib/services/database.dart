import 'dart:async';

import 'package:accelerometer/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "admin": user.admin,
        "verified": user.verified
      });
      return true;
    } catch (e) {
      print('ims: database $e');
      return false;
    }
  }

  Future<void> editUser(String uid, UserModel user) async {
    try {
      await _firestore.collection("users").doc(uid).set(user.toJson());
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      var _doc = await _firestore.collection("users").doc(uid).get();

      return UserModel.fromDocumentSnapshot(
          documentSnapshot: _doc); //documentSnapshot: _doc);
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  Stream<List<UserModel>> usersStream() {
    return _firestore
        .collection("users")
        //.orderBy("name", descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(UserModel.fromDocumentSnapshot(documentSnapshot: element));
      });
      return retVal;
    });
  }
/*
  Stream<List<MqttModel>> mqttStream() {
    return _firestore
        .collection("mqtts")
        //.orderBy("name", descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MqttModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(MqttModel.fromDocumentSnapshot(documentSnapshot: element));
      });
      return retVal;
    });
  }

  Stream<List<MqttModel>> userMqttStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("mqtt")
        //.orderBy("name", descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<MqttModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(MqttModel.fromDocumentSnapshot(documentSnapshot: element));
      });
      return retVal;
    });
  }

  Stream<List<Thing>> thingsStream() {
    return _firestore
        .collection("things")
        //.orderBy("name", descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Thing> retVal = List();
      query.docs.forEach((element) {
        retVal.add(Thing.fromDocumentSnapshot(documentSnapshot: element));
      });
      return retVal;
    });
  }

  Future<Thing> getThing(String thingID) async {
    var document = _firestore.collection('things').doc(thingID);
    var a = await document
        .snapshots()
        .first
        .then((value) => Thing.fromDocumentSnapshot(documentSnapshot: value));
    return a;
  }

  Future<void> addThing(Thing thing) async {
    try {
      //if true, add room id to users rooms collection
      _firestore.collection("things").doc(thing.id).set(thing.toJson());
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  Future<void> updateThing(Thing thing) async {
    try {
      await _firestore.collection("things").doc(thing.id).set(thing.toJson());
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  Future<void> updateDevice(String device, String payload) async {
    try {
      Map<String, dynamic> data = {'config': payload};
      await _firestore.collection("devices").doc(device).set(data);
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  Future<void> deleteThing(Thing thing) async {
    try {
      await _firestore.collection("things").doc(thing.id).delete();
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  Stream<List<ChannelModel>> channelStream(String deviceID) {
    return _firestore
        .collection("things")
        .doc(deviceID)
        .collection("channels")
        //.orderBy("name", descending: false)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ChannelModel> retVal = List();
      query.docs.forEach((element) {
        retVal
            .add(ChannelModel.fromDocumentSnapshot(documentSnapshot: element));
      });
      return retVal;
    });
  }

  Future<List<ChannelModel>> getChannels(String thingID) async {
    List<ChannelModel> aList = List();
    var a = await _firestore
        .collection('things')
        .doc(thingID)
        .collection('channels')
        .get();

    a.docs.forEach((element) {
      aList.add(ChannelModel.fromDocumentSnapshot(documentSnapshot: element));
    });
    return aList;
  }

  Future<void> addChannel(ChannelModel channel) async {
    try {
      //if true, add room id to users rooms collection
      _firestore
          .collection("things")
          .doc(channel.deviceID)
          .collection('channels')
          .doc(channel.channelID)
          .set(channel.toJson());
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }

  // Future<void> addRoom(RoomModel room) async {
  //   try {
  //     await _firestore.collection("rooms").doc(room.id).set(room.toJson());
  //   } catch (e) {
  //     print('ims: database $e');
  //     rethrow;
  //   }
  // }

  // Future<void> editRoom(RoomModel room) async {
  //   try {
  //     await _firestore.collection("rooms").doc(room.id).set(room.toJson());
  //   } catch (e) {
  //     print('ims: database $e');
  //     rethrow;
  //   }
  // }

  // Future<void> editUserRoom(String uid, RoomModel room) async {
  //   try {
  //     await _firestore
  //         .collection("users")
  //         .doc(uid)
  //         .collection("rooms")
  //         .doc(room.id)
  //         .set(room.toJson());
  //   } catch (e) {
  //     print('ims: database $e');
  //     rethrow;
  //   }
  // }

  // Future<void> deleteUserRoom(String uid, RoomModel room) async {
  //   try {
  //     await _firestore
  //         .collection("users")
  //         .doc(uid)
  //         .collection("rooms")
  //         .doc(room.id)
  //         .delete();
  //   } catch (e) {
  //     print('ims: database $e');
  //     rethrow;
  //   }
  // }

  Future<void> addMqttToUser(String uid, MqttModel mqtt) async {
    try {
      //if true, add room id to users rooms collection
      _firestore
          .collection("users")
          .doc(uid)
          .collection("mqtt")
          .doc(mqtt.id)
          //.set({"roomId": roomId});
          .set(mqtt.toJson());
    } catch (e) {
      print('ims: database $e');
      rethrow;
    }
  }
  */
}
