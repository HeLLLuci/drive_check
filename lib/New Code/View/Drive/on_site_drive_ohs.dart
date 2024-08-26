import 'package:drive_check/New%20Code/Controller/Audit/data_upload_controller.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:drive_check/New%20Code/View/Drive/task_completed_drive_ohs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../Components/Buttons/Image Picker Button/key_image_picker.dart';

class OnSiteDriveOhs extends StatelessWidget {
  final String taskId;
  OnSiteDriveOhs({super.key, required this.taskId});

  final DataUploadController controller = Get.find<DataUploadController>();

  @override
  Widget build(BuildContext context) {
    final List<String> imageKeys = [
      "Selfie on site from outside", "Selfie From Site", "KM Reading", "Company ID",  "Farmtocli", "Safety Passport", "Medical Certificate", "Insurance documents image", "First Aid Certificate", "DL", "RC", "PUC",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Drive OHS From Site",
            style: TextStyle(fontSize: 2.0.t, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill out the on-site drive OHS form"),
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
                  controller.uploadImageAndData(context, "OnSite", imageKeys, "OnSiteData", taskId, TaskCompleteDriveOhs(taskId: taskId));
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
