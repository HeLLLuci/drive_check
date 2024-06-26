import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../Database/get_employee_data.dart';

class PreSiteFormController extends GetxController {
  var isLoading = false.obs;
  var images = <String, File?>{}.obs;
  var employeeName = ''.obs;
  var siteTime = ''.obs;
  var siteId = ''.obs;
  var empId = ''.obs;
  var date = ''.obs;

  static final DateTime today = DateTime.now();
  static final String formattedDate = DateTime(today.year, today.month, today.day).toIso8601String().substring(0, 10);
  final TextEditingController dteName1Controller = TextEditingController();
  final TextEditingController dteName2Controller = TextEditingController();
  final TextEditingController riggerName1Controller = TextEditingController();
  final TextEditingController riggerName2Controller = TextEditingController();
  final TextEditingController siteIdController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController kmBeforeController = TextEditingController();
  final TextEditingController dtrAllocatedKmsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchAndSetEmployeeID();
  }

  Future<void> _fetchAndSetEmployeeID() async {
    Map<String, dynamic> userData = await FirestoreService.fetchUserData();
    employeeName.value = userData['Employee Name'] ?? '';
  }

  Future<void> pickImage(String imageKey) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      images[imageKey] = File(pickedFile.path);
    }
  }

  Future<void> uploadImageAndData(String siteType, List<String> imageKeys, String collectionName, String taskId, String submitDate) async {
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
            .collection('siteAllocation')
            .doc(taskId)
            .collection(collectionName)
            .doc(formattedDate);
        final docSnapshot = await docRef.get();

        final data = {
          'dteName1': dteName1Controller.text.trim(),
          'dteName2': dteName2Controller.text.trim(),
          'riggerName1': riggerName1Controller.text.trim(),
          'riggerName2': riggerName2Controller.text.trim(),
          'siteId': siteIdController.text.trim(),
          'vehicleNumber': vehicleNumberController.text.trim(),
          'driverName': driverNameController.text.trim(),
          'kmBefore': kmBeforeController.text.trim(),
          'dtrAllocatedKms': dtrAllocatedKmsController.text.trim(),
          'remarks': remarksController.text.trim(),
          'Date': submitDate,
          for (int i = 0; i < imageKeys.length; i++)
            '${imageKeys[i]}URL': imageURLs.length > i ? imageURLs[i] : null,
        };

        if (docSnapshot.exists) {
          await docRef.update(data);
        } else {
          await docRef.set(data);
        }
        _resetForm();
        isLoading.value = false;
        OverlayLoadingProgress.stop();
        _showError("Success", "Data uploaded successfully");

      } else {
        _showError("Oops", "User Not logged in");
      }
    } catch (e) {
      _showError("Oops", "Failed to upload data");
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
    dteName1Controller.clear();
    dteName2Controller.clear();
    riggerName1Controller.clear();
    riggerName2Controller.clear();
    siteIdController.clear();
    vehicleNumberController.clear();
    driverNameController.clear();
    kmBeforeController.clear();
    dtrAllocatedKmsController.clear();
    remarksController.clear();
    images.clear();
  }

  void _showError(String status, String message) {
    Get.snackbar(status, message, backgroundColor: status=='Oops' ? Colors.red.withOpacity(0.5) : Colors.green.withOpacity(0.5));
  }
}
