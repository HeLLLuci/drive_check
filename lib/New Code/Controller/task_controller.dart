import 'dart:io';
import 'package:drive_check/New%20Code/Helper/navigation_handler.dart';
import 'package:drive_check/New%20Code/View/checklist_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/task.dart';

class TaskController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController reasonController = TextEditingController();

  var tasks = <TaskModel>[].obs;
  var isLoading = true.obs;

  /*  variables for checklist page  */

  var activityAtNight = 'No'.obs;
  var activityType = 'RF'.obs;
  var workType = 'DT+DT'.obs;
  var vehicleType = 'Commercial Cab'.obs;
  var scopeOfWork = ''.obs;
  var circle = 'MH'.obs;
  var images = <Map<String, dynamic>>[
    {"imageName": "Company ID", "checked": false},
    {"imageName": "Farmtocli", "checked": false},
    {"imageName": "Medical Certificate", "checked": false},
    {"imageName": "Insurance Document", "checked": false},
    {"imageName": "Safety Passport", "checked": false},
    {"imageName": "FirstAid Certificate", "checked": false},
    {"imageName": "Driving License", "checked": false},
    {"imageName": "RC", "checked": false},
    {"imageName": "PUC", "checked": false},
  ].obs;
  var loading = false.obs;

  /* file path for on room ohs for audit */
  var Selfie = Rx<File?>(null);
  var PPEKit = Rx<File?>(null);
  var KMReading = Rx<File?>(null);
  var CompanyID = Rx<File?>(null);
  var Farmtocli = Rx<File?>(null);
  var SafetyPassport = Rx<File?>(null);
  var MedicalCertificate = Rx<File?>(null);
  var FirstAidCertificate = Rx<File?>(null);
  var DL = Rx<File?>(null);
  var RC = Rx<File?>(null);
  var PUC = Rx<File?>(null);


  /* file path for on site ohs for audit */

  var onSiteSelfie = Rx<File?>(null);
  var onSitePPEKit = Rx<File?>(null);
  var onSiteKMReading = Rx<File?>(null);
  var OHSSnap = Rx<File?>(null);
  var cabSelfie = Rx<File?>(null);

  /* file path for on complete ohs for audit */

  var onCompleteSelfie = Rx<File?>(null);
  var onCompleteKMReading = Rx<File?>(null);
  var onCompleteCabSelfie = Rx<File?>(null);

  /* file path for on returned ohs for audit */

  var onReturnedSelfie = Rx<File?>(null);
  var onReturnedCabSelfie = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      String uid = auth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        throw Exception('User document does not exist');
      }
      String employeeName = userDoc['Employee Name'] ?? '';
      DateTime today = DateTime.now();
      DateTime yesterday = today.subtract(Duration(days: 1));
      String formatDate(DateTime date) {
        int day = date.day;
        int month = date.month;
        int year = date.year;
        return '$day-$month-$year';
      }

      String todayStr = formatDate(today);
      String yesterdayStr = formatDate(yesterday);
      QuerySnapshot taskDocs = await _firestore
          .collection('siteAllocation')
          .where('Employee Name', isEqualTo: employeeName)
          .where('allocatedDate', whereIn: [todayStr, yesterdayStr]).get();
      tasks.value =
          taskDocs.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch tasks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptTask(TaskModel task) async {
    try {
      if (task.documentID.isEmpty) {
        throw Exception('Document ID is empty');
      }
      await _firestore
          .collection('siteAllocation')
          .doc(task.documentID)
          .set({'Acceptance': 'Accepted'}, SetOptions(merge: true)).then((_)=>Get.to(()=>ChecklistPage(task: task,), transition: Transition.fadeIn));
      Get.snackbar('Success', 'Task accepted');
      fetchTasks(); // Refresh the tasks list if needed
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept task: ${e.toString()}');
      print(e);
    }
  }

  Future<void> rejectTask(TaskModel task) async {
    try {
      if (task.documentID.isEmpty) {
        throw Exception('Document ID is empty');
      }
      await _firestore
          .collection('siteAllocation')
          .doc(task.documentID)
          .set({'Acceptance': 'Rejected', 'Reason': reasonController.text}, SetOptions(merge: true)).then((_)=>reasonController.clear());
      Get.snackbar('Success', 'Task rejected');
      fetchTasks(); // Refresh the tasks list if needed
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject task: ${e.toString()}');
      print(e);
    }
  }

  Future<void> submitChecklist(String taskId, TaskModel task) async {
    try {
      Map<String, dynamic> checklistData = {
        'activityAtNight': activityAtNight.value,
        'activityType': activityType.value,
        'workType': workType.value,
        'vehicleType': vehicleType.value,
        'scopeOfWork': scopeOfWork.value,
        'circle': circle.value,
        'images': images.map((image) => image).toList(),
      };

      // Merge this data with existing data in Firestore
      await _firestore
          .collection('siteAllocation')
          .doc(taskId)
          .set(checklistData, SetOptions(merge: true)).then((_){loading.value = false;});
      NavigationHandler.navigateBasedOnConditions(activityType.value, workType.value, task.documentID);
      Get.snackbar('Success', 'Checklist submitted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit checklist: ${e.toString()}');
    }
  }

  Future<void> uploadImagesAndStoreUrls({
    required List<Rx<File?>> imagePaths,
    required String collectionName,
    required String taskDocumentID,
    required Widget destination,
  }) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      String todayDate = DateTime.now().toIso8601String().substring(0, 10);
      DocumentReference documentRef = _firestore
          .collection('siteAllocation')
          .doc(taskDocumentID)
          .collection(collectionName)
          .doc(todayDate);
      Map<String, String> imageUrls = {};
      for (int i = 0; i < imagePaths.length; i++) {
        final File? imageFile = imagePaths[i].value;

        if (imageFile != null) {
          String storagePath = 'images/$taskDocumentID/$collectionName/${imageFile.path.split('/').last}';
          UploadTask uploadTask = storage.ref(storagePath).putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrls[imageFile.path.split('/').last] = downloadUrl;
        }
      }
      await documentRef.set({'imageUrls': imageUrls}, SetOptions(merge: true)).then((_)=>clearImagePaths());
      Get.snackbar('Success', 'Images uploaded and URLs stored successfully');
      Get.to(destination, transition: Transition.fadeIn);
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload images and store URLs: ${e.toString()}');
    }
  }


  /*  Clear Image Paths  */
  void clearImagePaths() {
    // Clear file paths for on-room OHS for audit
    Selfie.value = null;
    PPEKit.value = null;
    KMReading.value = null;
    CompanyID.value = null;
    Farmtocli.value = null;
    SafetyPassport.value = null;
    MedicalCertificate.value = null;
    FirstAidCertificate.value = null;
    DL.value = null;
    RC.value = null;
    PUC.value = null;

    // Clear file paths for on-site OHS for audit
    onSiteSelfie.value = null;
    onSitePPEKit.value = null;
    onSiteKMReading.value = null;
    OHSSnap.value = null;

    // Clear file paths for on-complete OHS for audit
    onCompleteSelfie.value = null;
    onCompleteKMReading.value = null;
    onCompleteCabSelfie.value = null;

    // Clear file paths for on-returned OHS for audit
    onReturnedSelfie.value = null;
    onReturnedCabSelfie.value = null;
    cabSelfie.value = null;
  }

}
