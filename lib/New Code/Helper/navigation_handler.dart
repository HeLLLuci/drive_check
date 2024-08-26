import 'package:drive_check/New%20Code/View/Audit/pre_site_audit_ohs.dart';
import 'package:drive_check/New%20Code/View/Drive/pre_site_drive_ohs.dart';
import 'package:get/get.dart';
import '../../Screens/pre_site_form.dart';

class NavigationHandler {
  static void navigateBasedOnConditions(String activityType, String workType, String taskId) {
    if(activityType == 'TI'){
      Get.to(()=>PreSiteForm(taskId: taskId,), transition: Transition.fadeIn);
    }
    else if(activityType == 'RF' && workType == 'DT+DT'){
      Get.to(()=>PreSiteDriveOhs(taskId: taskId,), transition: Transition.fadeIn);
    }
    else if(activityType == 'RF' && workType == 'DT+R'){
      Get.to(()=>PreSiteAuditOhs(taskId: taskId,), transition: Transition.fadeIn);
    }
    else if(activityType == 'RF' && workType=='R+R'){
      Get.to(()=>PreSiteAuditOhs(taskId: taskId,), transition: Transition.fadeIn);
    }
  }
}
