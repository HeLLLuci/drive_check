
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_check/Screens/pre_site_form.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTaskController extends GetxController {
  RxList<DocumentSnapshot> allTasks = RxList<DocumentSnapshot>();
  Rx<String>? id = "".obs;
  String? employeeName;

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeName();
    fetchTasks();
  }

  Future<void> fetchEmployeeName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      id?.value=user!.uid;
      if (user == null) return;

      // Fetch document from 'users' collection based on current user's UID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Extract 'Employee Name' from the document
      if (userDoc.exists) {
        employeeName = userDoc.get('Employee Name');
        print('Employee Name: $employeeName');
        // Ensure to update UI after fetching the employee name
        update();
      }
    } catch (e) {
      print('Error fetching employee name: $e');
    }
  }

  Future<void> fetchTasks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Fetch all tasks where Employee Name matches current user's name
      QuerySnapshot tasksSnapshot = await FirebaseFirestore.instance
          .collection('siteAllocation')
          .where('Employee Name', isEqualTo: employeeName)
          .get();

      allTasks.assignAll(tasksSnapshot.docs);
      print('Fetched ${allTasks.length} tasks');

    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  Future<void> acceptTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('siteAllocation').doc(taskId).update({
        'Acceptance': "Accepted",
      });
      print("UID is: ${id?.value}");
      await FirebaseFirestore.instance.collection('users').doc(id?.value).update(
          {'state': 'preSite', 'taskId': taskId},).then((_){
          Get.snackbar('Done','Task $taskId accepted');
          Get.to(()=>PreSiteForm(taskId: taskId,));
      });
    } catch (e) {
      print(e);
      Get.snackbar('Oops!','Error accepting task: $e');
    }
  }

  Future<void> rejectTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('siteAllocation').doc(taskId).update({
        'Acceptance': "Rejected",
      });
      print('Task $taskId rejected');
    } catch (e) {
      print('Error rejecting task: $e');
    }
  }
}
