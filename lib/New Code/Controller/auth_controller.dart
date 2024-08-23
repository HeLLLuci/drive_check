import 'package:drive_check/New%20Code/View/availability_page.dart';
import 'package:drive_check/New%20Code/View/task_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user.dart';

class AuthController extends GetxController {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  var isLoading = false.obs;
  var obscureText = false.obs;
  UserModel? _user;
  var uid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  // Method to initialize the user information
  Future<void> _initializeUser() async {
    try {
      User? firebaseUser = auth.currentUser;
      if (firebaseUser != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          _user = UserModel.fromJson(userDoc.data()!, firebaseUser.uid);
        }
      }
    } catch (e) {
      print("Error initializing user: $e");
    }
  }

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        var userDoc = await db
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          _user = UserModel.fromJson(userDoc.data()!, firebaseUser.uid);

          Get.offAll(AvailabilityPage());
          Get.snackbar("Success", "Logged in successfully");
        }
      }
      isLoading.value = false;
      clearControllers();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
  void updateAvailability(bool isAvailable, String? reason) {
    String uid = auth.currentUser!.uid;
    String availabilityValue = isAvailable ? 'Available' : 'Unavailable';
    reason!.isEmpty ? db.collection('users').doc(uid).update({
      'Availability': availabilityValue
    }).then((_) {
      clearControllers();
      Get.to(()=>TaskScreen(), transition: Transition.fadeIn);
      Get.snackbar("Success", "Availability updated successfully");
    }).catchError((error) {
      clearControllers();
      Get.snackbar("Error", "Failed to update availability: $error");
    }) : db.collection('users').doc(uid).update({
      'Availability': availabilityValue,
      'Reason': reason
    }).then((_) {
      clearControllers();
      Get.snackbar("Success", "Availability updated successfully");
    }).catchError((error) {
      clearControllers();
      Get.snackbar("Error", "Failed to update availability: $error");
    });
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    reasonController.clear();
  }

  UserModel? get user => _user;

  void clearStoredUser() {
    _user = null;
  }
}
