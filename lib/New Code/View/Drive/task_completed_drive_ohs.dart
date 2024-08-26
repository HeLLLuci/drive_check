import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:drive_check/New%20Code/View/Drive/post_site_drive_ohs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../Components/Buttons/Image Picker Button/key_image_picker.dart';
import '../../Controller/Audit/data_upload_controller.dart';

class TaskCompleteDriveOhs extends StatelessWidget {
  final String taskId;
  TaskCompleteDriveOhs({super.key, required this.taskId});

  final DataUploadController controller = Get.find<DataUploadController>();

  @override
  Widget build(BuildContext context) {
    final List<String> imageKeys = [
      "Site Leaving Selfie", "Cab Selfie", "KM Reading",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Drive OHS After Task Completion",
            style: TextStyle(fontSize: 2.5.t, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill out the task completed drive OHS form"),
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
                  controller.uploadImageAndData(context, "taskComplete", imageKeys, "taskCompleteData", taskId, PostSiteDriveOhs(taskId: taskId));
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
