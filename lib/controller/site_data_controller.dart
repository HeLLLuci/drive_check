import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../Database/get_employee_data.dart';

class SiteDataController extends GetxController {
  var isLoading = false.obs;
  var cabAvailable = false.obs;
  var images = <String, File?>{}.obs;
  var employeeName = ''.obs;
  var siteTime = ''.obs;
  var siteId = ''.obs;
  var empId = ''.obs;

  static final DateTime today = DateTime.now();
  static final String formattedDate = DateTime(today.year, today.month, today.day).toIso8601String().substring(0, 10);

  final TextEditingController siteIdController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchAndSetEmployeeID();
  }

  Future<void> _fetchAndSetEmployeeID() async {
    Map<String, dynamic> userData = await FirestoreService.fetchUserData();
    empId.value = userData['Employee ID'] ?? '';
    employeeName.value = userData['Employee Name'] ?? '';
    empIdController.text = empId.value;
  }

  Future<void> pickImage(String imageKey) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      images[imageKey] = File(pickedFile.path);
    }
  }

  Future<void> uploadImageAndData(String siteType, List<String> imageKeys, String collectionName) async {
    isLoading.value = true;
    final List<Future<String>> uploadTasks = [];

    for (var key in imageKeys) {
      if (images[key] != null) uploadTasks.add(_uploadImage(images[key]!, key));
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? uid = user?.uid;
      final List<String> imageURLs = await Future.wait(uploadTasks);

      if (uid != null) {
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection(collectionName)
            .doc(formattedDate);
        final docSnapshot = await docRef.get();

        final data = {
          'Site ID': siteId.value,
          'Employee ID': empId.value,
          for (int i = 0; i < imageKeys.length; i++)
            '${imageKeys[i]}URL': imageURLs.length > i ? imageURLs[i] : null,
        };

        if (docSnapshot.exists) {
          await docRef.update(data);
        } else {
          await docRef.set(data);
        }

        MotionToast.success(
            title: Text("Success"),
            description: Text("Data submitted successfully")
        ).show(Get.context!);

        _resetForm();
      } else {
        _showError("User not logged in");
      }
    } catch (e) {
      _showError("Failed to upload data");
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _uploadImage(File imageFile, String imageName) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/$employeeName/$formattedDate/$siteTime/$imageName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading $imageName: $e');
      return '';
    }
  }

  void _resetForm() {
    siteId.value = '';
    images.clear();
    siteIdController.clear();
  }

  void _showError(String message) {
    MotionToast.error(
        title: Text("Oops!"),
        description: Text(message)
    ).show(Get.context!);
  }
}
