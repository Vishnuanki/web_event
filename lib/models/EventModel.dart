import 'package:cloud_firestore/cloud_firestore.dart';
class EventModel {
  final String id;
  final String addedOn;
  final String address;
  final String description;
  final String endDateTiem;
  final String eventCategory;
  final String eventName;
  final String image;
  final String price;
  final String startDateTime;
  final String subCategory;
  final String status;

  const EventModel(
      {
       required this.id, 
      required this.addedOn,
      required this.address,
      required this.description,
      required this.endDateTiem,
      required this.eventCategory,
      required this.eventName,
      required this.image,
      required this.price,
      required this.startDateTime,
      required this.subCategory,
      required this.status
      });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data =  doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      addedOn: data["addedOn"] ?? 'unknown',
      address: data["address"] ?? 'unknown',
      description: data["description"] ?? 'unknown',
      endDateTiem: data["endDateTime"] ?? 'unknown',
      eventCategory: data["eventCategory"] ?? 'unknown',
      eventName: data["eventName"] ?? 'unknown',
      image: data["image"] ?? 'unknown',
      price: data["price"] ?? 'unknown',
      startDateTime: data["startDateTime"] ?? 'unknown',
      subCategory: data["subCategory"] ?? 'unknown',
      status:data["status"]??"pending",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "addedOn": addedOn,
      "address": address,
      "description": description,
      "endDataTime": endDateTiem,
      "eventCategory": eventCategory,
      "eventName": eventName,
      "image": image,
      "price": price,
      "startDateTime": startDateTime,
      "subCategory": subCategory,
      "status":status,
    };
  }
}
