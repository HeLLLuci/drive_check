import 'package:drive_check/New%20Code/View/availability_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var obscureText = false.obs;


  Future<void> loginUser() async{
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    auth.signInWithEmailAndPassword(email: email, password: password).then((_) {
      Get.offAll(AvailabilityPage());
      isLoading.value = false;
      Get.snackbar("Succes", "Logged in successfully");
      clearControllers();
    });
  }


  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}