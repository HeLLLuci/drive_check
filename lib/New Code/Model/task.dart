import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String acceptance;
  final String employeeName;
  final String allocatedDate;
  final String latitude;
  final String longitude;
  final String siteID;
  final String documentID;

  TaskModel({
    required this.acceptance,
    required this.employeeName,
    required this.allocatedDate,
    required this.latitude,
    required this.longitude,
    required this.siteID,
    required this.documentID,
  });

  // Convert Firestore document to TaskModel model
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      acceptance: data['Acceptance'] ?? '',
      employeeName: data['Employee Name'] ?? '',
      allocatedDate: data['allocatedDate'] ?? '',
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
      siteID: data['siteID'] ?? '',
      documentID: doc.id,
    );
  }

  // Convert TaskModel model to JSON
  Map<String, dynamic> toJson() {
    return {
      'Acceptance': acceptance,
      'Employee Name': employeeName,
      'allocatedDate': allocatedDate,
      'latitude': latitude,
      'longitude': longitude,
      'siteID': siteID,
    };
  }
}
