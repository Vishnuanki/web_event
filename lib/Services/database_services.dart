import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_event/models/EventModel.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<EventModel>> getPendingEvents(value) {
    return _db
        .collection("events")
        .where("status", isEqualTo: value)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }

  Stream<List<EventModel>> getAllEvents() {
    return _db.collection("events").snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList()
    );
  }

  // Future<void> addEvent(EventModel event) async {
  //   await _db.collection().add(event.toMap());
  // }

  Future<void> UpdateEvent({
    required String collectionPath,
    required String docId,
    required String field,
    required dynamic newValue,
  })async{
    try {
      await _db.collection(collectionPath).doc(docId).update({field: newValue});
    }catch (e) {
      throw Exception("Error updating field: $e");
    }

  }

  Future<void> deleteDocument(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }


  
}
