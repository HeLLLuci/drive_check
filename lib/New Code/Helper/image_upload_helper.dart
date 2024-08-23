import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageUploadHandler {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadImage(File imageFile, String imageName, String employeeName, String formattedDate, String siteTime) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('images/$employeeName/$formattedDate/$siteTime/$imageName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading $imageName: $e');
      return null;
    }
  }

  Future<void> saveData(String collectionName, String taskId, String documentId, Map<String, dynamic> data) async {
    final DocumentReference docRef = _firestore
        .collection('siteAllocation')
        .doc(taskId)
        .collection(collectionName)
        .doc(documentId);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update(data);
    } else {
      await docRef.set(data);
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
