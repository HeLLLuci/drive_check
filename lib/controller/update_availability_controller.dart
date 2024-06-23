import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Widgets/new_button.dart';

class UpdateAvailabilityController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final reasonController = TextEditingController();
  var isLoading = false.obs;

  Future<void> updateAvailability(String availability, String? reason) async {
    isLoading.value = true;
    String uid = auth.currentUser!.uid;

    Map<String, dynamic> data = {
      "Availability": availability,
    };

    if (reason != null) {
      data["Reason"] = reason;
    }

    try {
      await db.collection('users').doc(uid).set(data, SetOptions(merge: true));
      Get.snackbar("Success", "Availability updated successfully",
          backgroundColor: Color(0xFF159757).withOpacity(0.4));
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message ?? "Something went wrong",
          backgroundColor: Color(0xFF159757).withOpacity(0.4));
    } finally {
      isLoading.value = false;
    }
  }

  void handleNo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewButton(
                  buttonText: "Cancel",
                  onTap: () => Navigator.pop(context),
                ),
                NewButton(
                  buttonText: "Submit",
                  onTap: () {
                    if (reasonController.text.isEmpty) {
                      Get.snackbar("Oops!", "You have to specify the reason",
                          backgroundColor:
                          Color(0xFF159757).withOpacity(0.4));
                    } else {
                      updateAvailability("Not Available",
                          reasonController.text.trim());
                      Navigator.pop(context); // Close the dialog
                    }
                  },
                ),
              ],
            )
          ],
          content: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    "Enter your reason",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle: Text(
                    "Your reason will be only accepted by admin",
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider(
                  color: Color(0xFF159757),
                ),
                TextFormField(
                  controller: reasonController,
                  decoration: InputDecoration(
                      labelText: "Enter Reason",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
