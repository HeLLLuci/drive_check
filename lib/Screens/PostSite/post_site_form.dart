import 'package:drive_check/Screens/PostSite/post_site_form_controller.dart';
import 'package:drive_check/Screens/PostSite/post_site_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class PostSiteForm extends StatefulWidget {
  final String taskId;
  const PostSiteForm({Key? key, required this.taskId}) : super(key: key);

  @override
  State<PostSiteForm> createState() => _PostSiteFormState();
}

class _PostSiteFormState extends State<PostSiteForm> {
  final List<String> imageKeys = ["Site leaving selfie", "Photo of cab", "KM Reading Photo", "Selfie From Room", "Cab Selfie From room"];
  DateTime? selectedDate;

  PostSiteFormController _controller = Get.put(PostSiteFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Post site form",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill the form of audit for post site"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("${imageKeys[0]}: "),
                      PostSiteImagePickerButton(title: imageKeys[0], imageKey: imageKeys[0]),
                      SizedBox(height: 16),
                      Text("${imageKeys[1]}: "),
                      PostSiteImagePickerButton(title: imageKeys[1], imageKey: imageKeys[1]),
                      SizedBox(height: 16),
                      Text("${imageKeys[2]}: "),
                      PostSiteImagePickerButton(title: imageKeys[2], imageKey: imageKeys[2]),
                      SizedBox(height: 16),
                      Text("${imageKeys[3]}: "),
                      PostSiteImagePickerButton(title: imageKeys[3], imageKey: imageKeys[3]),
                      SizedBox(height: 16),
                      Text("${imageKeys[4]}: "),
                      PostSiteImagePickerButton(title: imageKeys[4], imageKey: imageKeys[4]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: (){
                OverlayLoadingProgress.start(context,
                  widget: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Lottie.asset("assets/Animations/loading.json"),
                    ),
                  ),
                );
                _controller.uploadImageAndData("preSite", imageKeys, "PostSiteData", widget.taskId, selectedDate.toString());
              }, child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

}
