import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'on_site_form_controller.dart';
import 'on_site_image_picker.dart';

class OnSiteForm extends StatefulWidget {
  final String taskId;
  const OnSiteForm({Key? key, required this.taskId}) : super(key: key);

  @override
  State<OnSiteForm> createState() => _OnSiteFormState();
}

class _OnSiteFormState extends State<OnSiteForm> {
  final List<String> imageKeys = ["Selfie From Site", "PPE Kit Image", "KM Reading", "Company ID",  "Farmtocli", "Safety Passport", "Medical Certificate", "Insurance documents image", "First Aid Certificate", "DL", "RC", "PUC", "OHS SnapShot"];
  DateTime? selectedDate;

  OnSiteFormController _controller = Get.put(OnSiteFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "On site form",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill the form of audit for on site"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name"),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter Riggor name 1",
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
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("${imageKeys[0]}: "),
                      OnSiteImagePickerButton(title: imageKeys[0], imageKey: imageKeys[0]),
                      SizedBox(height: 16),
                      Text("${imageKeys[1]}: "),
                      OnSiteImagePickerButton(title: imageKeys[1], imageKey: imageKeys[1]),
                      SizedBox(height: 16),
                      Text("${imageKeys[2]}: "),
                      OnSiteImagePickerButton(title: imageKeys[2], imageKey: imageKeys[2]),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("${imageKeys[3]}: "),
                      OnSiteImagePickerButton(title: imageKeys[3], imageKey: imageKeys[3]),
                      SizedBox(height: 16),
                      Text("${imageKeys[4]}: "),
                      OnSiteImagePickerButton(title: imageKeys[4], imageKey: imageKeys[4]),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("${imageKeys[5]}: "),
                      OnSiteImagePickerButton(title: imageKeys[5], imageKey: imageKeys[5]),
                      SizedBox(height: 16),
                      Text("${imageKeys[6]}: "),
                      OnSiteImagePickerButton(title: imageKeys[6], imageKey: imageKeys[6]),
                      SizedBox(height: 16),
                      Text("${imageKeys[7]}: "),
                      OnSiteImagePickerButton(title: imageKeys[7], imageKey: imageKeys[7]),
                      SizedBox(height: 16),
                      Text("${imageKeys[8]}: "),
                      OnSiteImagePickerButton(title: imageKeys[8], imageKey: imageKeys[8]),
                      SizedBox(height: 16),
                      Text("${imageKeys[9]}: "),
                      OnSiteImagePickerButton(title: imageKeys[9], imageKey: imageKeys[9]),
                      SizedBox(height: 16),
                      Text("${imageKeys[10]}: "),
                      OnSiteImagePickerButton(title: imageKeys[10], imageKey: imageKeys[10]),
                      SizedBox(height: 16),
                      Text("${imageKeys[11]}: "),
                      OnSiteImagePickerButton(title: imageKeys[11], imageKey: imageKeys[11]),
                      SizedBox(height: 16),
                      Text("${imageKeys[12]}: "),
                      OnSiteImagePickerButton(title: imageKeys[12], imageKey: imageKeys[12]),
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
                _controller.uploadImageAndData("preSite", imageKeys, "PreSiteData", widget.taskId, selectedDate.toString());
              }, child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

}
