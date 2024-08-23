import 'package:drive_check/New%20Code/Controller/Audit/data_upload_controller.dart';
import 'package:drive_check/New%20Code/View/Audit/task_completed_audit_ohs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../Components/Buttons/Image Picker Button/key_image_picker.dart';

class OnSiteAuditOhs extends StatelessWidget {
  final String taskId;
  OnSiteAuditOhs({super.key, required this.taskId});

  final DataUploadController controller = Get.find<DataUploadController>();

  @override
  Widget build(BuildContext context) {
    final List<String> imageKeys = [
      "Selfie From Site", "PPE Kit Image", "KM Reading", "Company ID",  "Farmtocli", "Safety Passport", "Medical Certificate", "Insurance documents image", "First Aid Certificate", "DL", "RC", "PUC", "OHS SnapShot"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Audit OHS From Site",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill out the on-site audit OHS form"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var key in imageKeys)
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$key: "),
                        KeyImagePicker(title: key, imageKey: key),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  OverlayLoadingProgress.start(context,
                    widget: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Lottie.asset("assets/Animations/loading.json"),
                      ),
                    ),
                  );
                  controller.uploadImageAndData(context, "OnSite", imageKeys, "OnSiteData", taskId, TaskCompleteAuditOhs(taskId: taskId));
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
