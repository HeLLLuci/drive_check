import 'package:drive_check/New%20Code/View/Audit/on_site_audit_ohs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import '../../Components/Buttons/Image Picker Button/key_image_picker.dart';
import '../../Controller/Audit/data_upload_controller.dart';
import '../../Helper/colors.dart';

class PreSiteAuditOhs extends StatelessWidget {
  final String taskId;
  PreSiteAuditOhs({super.key, required this.taskId});

  final DataUploadController controller = Get.find<DataUploadController>();

  @override
  Widget build(BuildContext context) {
    final List<String> imageKeys = [
      "Selfie Before Leaving", "PPE Kit Image", "KM Reading", "Company ID",  "Farmtocli", "Safety Passport", "Medical Certificate", "Insurance documents image", "First Aid Certificate", "DL", "RC", "PUC",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Audit OHS From Room",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill out the pre-site audit OHS form"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controller.rgr1Name,
                  decoration: InputDecoration(
                      labelText: "Enter Rigger name 1",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1.0,
                              color: greyColor
                          )
                      )
                  ),
                ),
              ),
              Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controller.rgr2Name,
                  decoration: InputDecoration(
                      labelText: "Enter Rigger name 2",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1.0,
                              color: greyColor
                          )
                      )
                  ),
                ),
              ),
              Card(
                elevation: 0,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controller.dtrName,
                  decoration: InputDecoration(
                      labelText: "Enter DTE name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              width: 1.0,
                              color: greyColor
                          )
                      )
                  ),
                ),
              ),
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
                  controller.uploadImageAndData(context, "preSite", imageKeys, "PreSiteData", taskId, OnSiteAuditOhs(taskId: taskId));
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
