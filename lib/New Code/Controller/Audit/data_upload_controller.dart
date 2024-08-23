import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../../Database/get_employee_data.dart';

class DataUploadController extends GetxController {
  var isLoading = false.obs;
  var images = <String, File?>{}.obs;
  var employeeName = ''.obs;
  var siteTime = ''.obs;

  // Variable to store image URLs
  final Map<String, String> imageURLs = {};

  static final DateTime today = DateTime.now();
  static final String formattedDate =
      DateTime(today.year, today.month, today.day)
          .toIso8601String()
          .substring(0, 10);
  final TextEditingController rgr1Name = TextEditingController();
  final TextEditingController rgr2Name = TextEditingController();
  final TextEditingController dtrName = TextEditingController();

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
    if (isLoading.value) {
      Get.snackbar('Error', 'Please wait, an image is being processed.');
      return;
    }

    try {
      isLoading.value = true;
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        images[imageKey] = File(pickedFile.path);
        print('Picked image for key: $imageKey'); // Debug statement
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadImageAndData(BuildContext context, String siteType, List<String> imageKeys,
      String collectionName, String taskId, Widget destination) async {
    isLoading.value = true;
    imageURLs.clear(); // Clear previous URLs

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      String? uid = user?.uid;

      // Upload images and store their URLs
      for (var key in imageKeys) {
        if (images[key] != null) {
          final url = await _uploadImage(images[key]!, key);
          imageURLs[key] = url;
        }
      }

      if (uid != null) {
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('siteAllocation')
            .doc(taskId)
            .collection(collectionName)
            .doc(formattedDate);
        final docSnapshot = await docRef.get();

        // Prepare data for Firestore update
        final data = {
          for (var key in imageKeys)
            '${key} URL': imageURLs[key] ??
                '',
        };

        if (docSnapshot.exists) {
          await docRef.update(data);
        } else {
          await docRef.set(data);
        }
        OverlayLoadingProgress.stop();
        _showError("Success", "Data uploaded successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>destination));
        _resetForm();
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
    print('Uploading image for key: $imageName'); // Debug statement
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(
          'images/$employeeName/$formattedDate/$siteTime/$imageName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading $imageName: $e');
      return '';
    }
  }

  void _resetForm() {
    images.clear();
  }

  void _showError(String status, String message) {
    Get.snackbar(status, message,
        backgroundColor: status == 'Oops'
            ? Colors.red.withOpacity(0.5)
            : Colors.green.withOpacity(0.5));
  }
}
