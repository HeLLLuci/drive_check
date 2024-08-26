import 'package:drive_check/New%20Code/View/availability_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../Components/Buttons/Image Picker Button/key_image_picker.dart';
import '../../Controller/Audit/data_upload_controller.dart';
class PostSiteDriveOhs extends StatelessWidget {
  final String taskId;
  PostSiteDriveOhs({super.key, required this.taskId});

  final DataUploadController controller = Get.find<DataUploadController>();

  @override
  Widget build(BuildContext context) {
    final List<String> imageKeys = [
      "Selfie From Room", "Selfie With Cab", "KM Reading"
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Drive OHS From Room",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill out the post-site drive OHS form"),
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
                  controller.uploadImageAndData(context, "postSite", imageKeys, "postSiteData", taskId, AvailabilityPage());
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
