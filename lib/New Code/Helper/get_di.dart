import 'package:drive_check/New%20Code/Controller/auth_controller.dart';
import 'package:get/get.dart';

Future<void> init() async{
  Get.lazyPut(()=>AuthController());
}