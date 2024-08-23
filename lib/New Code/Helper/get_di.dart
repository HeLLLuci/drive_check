import 'package:drive_check/New%20Code/Controller/Audit/data_upload_controller.dart';
import 'package:drive_check/New%20Code/Controller/auth_controller.dart';
import 'package:drive_check/New%20Code/Controller/task_controller.dart';
import 'package:get/get.dart';

Future<void> init() async{
  Get.lazyPut(()=>AuthController(), fenix: true);
  Get.lazyPut(()=>TaskController(), fenix: true);
  Get.lazyPut(()=>DataUploadController(), fenix: true);
}