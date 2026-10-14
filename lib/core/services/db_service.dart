import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_model.dart';

class DbService {
  static var firebase = FirebaseFirestore.instance;

  static Future<void> addEvent(EventModel event) async {
    var doc = firebase.collection("Events").doc();
    event.id = doc.id;
    await doc.set(event.toJson());
  }

  static Future<void> deleteEvent(String id) async {
    await firebase.collection("Events").doc(id).delete();
  }

  static Future<void> updateEvent(EventModel event) async {
    await firebase.collection("Events").doc(event.id).update(event.toJson());
  }

  static Future<List<EventModel>> getEvents(String? categoryId) async {
    List<EventModel> events = [];
    QuerySnapshot<Map<String, dynamic>> data;
    if (categoryId == null) {
      data = await firebase.collection("Events").get();
    } else {
      data = await firebase
          .collection("Events")
          .where("categoryId", isEqualTo: categoryId)
          .get();
    }

    for (var e in data.docs) {
      var event = EventModel.fromJson(e.data());
      events.add(event);
    }

    return events;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getEventsStream(
    String? categoryId,
  ) {
    Stream<QuerySnapshot<Map<String, dynamic>>> data;
    if (categoryId == null) {
      data = firebase.collection("Events").snapshots();
    } else {
      data = firebase
          .collection("Events")
          .where("categoryId", isEqualTo: categoryId)
          .snapshots();
    }

    return data;
  }

  static Future<List<EventModel>> getFavEvents() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    List<EventModel> events = [];
    var data = await firebase
        .collection("Events")
        .where("usersFav", arrayContains: userId)
        .get();

    for (var e in data.docs) {
      var event = EventModel.fromJson(e.data());
      events.add(event);
    }

    return events;
  }

  static Future<void> toggleFav(EventModel event) async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    if (event.usersFav.contains(userId)) {
      event.usersFav.remove(userId);
    } else {
      event.usersFav.add(userId);
    }
    await firebase.collection("Events").doc(event.id).update(event.toJson());
  }
}
