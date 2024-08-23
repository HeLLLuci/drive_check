import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../New Code/Helper/image_upload_helper.dart';

class PreSiteFormController extends GetxController {
  var isLoading = false.obs;
  var images = <String, File?>{}.obs;
  var employeeName = ''.obs;
  var siteTime = ''.obs;
  var siteId = ''.obs;
  var date = ''.obs;

  static final DateTime today = DateTime.now();
  static final String formattedDate = DateTime(today.year, today.month, today.day).toIso8601String().substring(0, 10);
  final TextEditingController dteName1Controller = TextEditingController();
  final TextEditingController riggerName1Controller = TextEditingController();
  final TextEditingController riggerName2Controller = TextEditingController();

  final ImageUploadHandler _imageHandler = ImageUploadHandler();

  @override
  void onInit() {
    super.onInit();
    _fetchAndSetEmployeeID();
  }

  Future<void> _fetchAndSetEmployeeID() async {
    // Assume you have a service to fetch user data
    // Map<String, dynamic> userData = await FirestoreService.fetchUserData();
    // employeeName.value = userData['Employee Name'] ?? '';
    employeeName.value = "John Doe";  // Placeholder, replace with actual data fetching logic
  }

  Future<void> uploadImageAndData(String siteType, List<String> imageKeys, String collectionName, String taskId, String submitDate) async {
    isLoading.value = true;
    final List<Future<String?>> uploadTasks = [];

    for (var key in imageKeys) {
      if (images[key] != null) {
        uploadTasks.add(_imageHandler.uploadImage(images[key]!, key, employeeName.value, formattedDate, siteTime.value));
      }
    }

    try {
      String? uid = _imageHandler.getCurrentUser()?.uid;
      final List<String?> imageURLs = await Future.wait(uploadTasks);

      if (uid != null) {
        final data = {
          'dteName1': dteName1Controller.text.trim(),
          'riggerName1': riggerName1Controller.text.trim(),
          'riggerName2': riggerName2Controller.text.trim(),
          for (int i = 0; i < imageKeys.length; i++)
            '${imageKeys[i]} URL': imageURLs.length > i ? imageURLs[i] : null,
        };

        await _imageHandler.saveData(collectionName, taskId, formattedDate, data);

        _resetForm();
        _showSnackbar("Success", "Data uploaded successfully", Colors.green);
      } else {
        _showSnackbar("Oops", "User Not logged in", Colors.red);
      }
    } catch (e) {
      _showSnackbar("Oops", "Failed to upload data", Colors.red);
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    dteName1Controller.clear();
    riggerName1Controller.clear();
    riggerName2Controller.clear();
    images.clear();
  }

  void _showSnackbar(String title, String message, Color backgroundColor) {
    Get.snackbar(title, message, backgroundColor: backgroundColor.withOpacity(0.5));
  }
}
