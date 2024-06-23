import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/material.dart';

class PreSiteFormController extends GetxController {
  var isLoading = false.obs;
  var images = <String, File?>{}.obs;
  var selectedDate = Rx<DateTime?>(null);
  var nightActivity = RxString('Yes');
  var selectedCircle = RxString('MH');
  var selectedASPName = RxString('ASP 1');
  var selectedScopeOfWork = RxString('11 B');
  var selectedActivityType = RxString('DT');
  var selectedVehicle = RxString('Commercial Cab');
  var selectedStatus = RxString('C-OK');

  static final DateTime today = DateTime.now();
  static final String formattedDate = DateTime(today.year, today.month, today.day)
      .toIso8601String()
      .substring(0, 10);

  final TextEditingController dteName1Controller = TextEditingController();
  final TextEditingController dteName2Controller = TextEditingController();
  final TextEditingController riggerName1Controller = TextEditingController();
  final TextEditingController riggerName2Controller = TextEditingController();
  final TextEditingController siteIdController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController kmBeforeController = TextEditingController();
  final TextEditingController kmAfterController = TextEditingController();
  final TextEditingController kmReadingSiteReadingController = TextEditingController();
  final TextEditingController kmReadingDriveCompletionReadingController =
  TextEditingController();
  final TextEditingController kmAfterDriveCompletionReadingController =
  TextEditingController();
  final TextEditingController dtrAllocatedKmsController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  Future<void> pickImage(String imageKey) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      images[imageKey] = File(pickedFile.path);
    }
  }

  Future<void> uploadDataToFirestore() async {
    isLoading.value = true;
    final List<Future<String>> uploadTasks = [];

    try {
      // Upload images
      for (var entry in images.entries) {
        if (entry.value != null) {
          uploadTasks.add(_uploadImage(entry.value!, entry.key));
        }
      }

      // Wait for all image uploads to complete
      final List<String> imageURLs = await Future.wait(uploadTasks);

      // Construct data to save to Firestore
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? uid = user?.uid;

      if (uid != null) {
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('preSiteForms')
            .doc(formattedDate);

        final data = {
          'Site ID': siteIdController.text,
          'DTE Name 1': dteName1Controller.text,
          'DTE Name 2': dteName2Controller.text,
          'Rigger Name 1': riggerName1Controller.text,
          'Rigger Name 2': riggerName2Controller.text,
          'Vehicle Number': vehicleNumberController.text,
          'Driver Name': driverNameController.text,
          'KM Before': kmBeforeController.text,
          'KM After': kmAfterController.text,
          'KM Reading Site': kmReadingSiteReadingController.text,
          'KM Reading Drive Completion': kmReadingDriveCompletionReadingController.text,
          'KM After Drive Completion': kmAfterDriveCompletionReadingController.text,
          'DTR Allocated KMs': dtrAllocatedKmsController.text,
          'Remarks': remarksController.text,
          'Night Activity': nightActivity.value,
          'Selected Circle': selectedCircle.value,
          'Selected ASP Name': selectedASPName.value,
          'Selected Scope of Work': selectedScopeOfWork.value,
          'Selected Activity Type': selectedActivityType.value,
          'Selected Vehicle Type': selectedVehicle.value,
          'RA OHS Status': selectedStatus.value,
          'Selected Date': selectedDate.value.toString(),
          'Image URLs': imageURLs,
        };

        // Check if the document exists
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          await docRef.update(data);
        } else {
          await docRef.set(data);
        }

        // Show success message
        MotionToast.success(
          title: Text("Success"),
          description: Text("Data submitted successfully"),
        ).show(Get.context!);

        // Clear form after successful submission
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
          .child('images/preSiteForms/$formattedDate/$imageName.jpg');
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
    kmAfterController.clear();
    kmReadingSiteReadingController.clear();
    kmReadingDriveCompletionReadingController.clear();
    kmAfterDriveCompletionReadingController.clear();
    dtrAllocatedKmsController.clear();
    remarksController.clear();
    images.clear();
    selectedDate.value = null;
    nightActivity.value = 'Yes';
    selectedCircle.value = 'MH';
    selectedASPName.value = 'ASP 1';
    selectedScopeOfWork.value = '11 B';
    selectedActivityType.value = 'DT';
    selectedVehicle.value = 'Commercial Cab';
    selectedStatus.value = 'C-OK';
  }

  void _showError(String message) {
    MotionToast.error(
      title: Text("Oops!"),
      description: Text(message),
    ).show(Get.context!);
  }
}
