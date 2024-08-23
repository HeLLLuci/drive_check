import 'package:drive_check/controller/pre_site_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controller/pre_site_image_picker.dart';

class PreSiteForm extends StatefulWidget {
  final String taskId;
  const PreSiteForm({Key? key, required this.taskId}) : super(key: key);

  @override
  State<PreSiteForm> createState() => _PreSiteFormState();
}

class _PreSiteFormState extends State<PreSiteForm> {
  final List<String> imageKeys = ["Selfie from room", "PPE Kit Image", "KM Reading", "Company ID",  "Farmtocli", "Safety Passport", "Medical Certificate", "Insurance documents image", "First Aid Certificate", "DL", "RC", "PUC"];

  PreSiteFormController _controller = Get.put(PreSiteFormController());

  @override
  void initState() {
    super.initState();
  }
  Future<void> requestPermissions() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print("Permission Granted");
    } else if (status.isDenied) {
      // Handle permission denied
    } else if (status.isPermanentlyDenied) {
      // Open app settings for the user to grant permissions
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: ListTile(
          title: Text(
            "Pre site form",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Fill the pre site form for Audit"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text("DTE Name 1: "),
                      TextFormField(
                        controller: _controller.dteName1Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter DTE Name 1',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Rigger Name 1: "),
                      TextFormField(
                        controller: _controller.riggerName1Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Rigger Name 1',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Rigger Name 2: "),
                      TextFormField(
                        controller: _controller.riggerName2Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Rigger Name 2',
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${imageKeys[0]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[0]),
                      SizedBox(height: 16),
                      Text("${imageKeys[1]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[1]),
                      SizedBox(height: 16),
                      Text("${imageKeys[2]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[2]),
                      SizedBox(height: 16),
                      Text("${imageKeys[3]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[3]),
                      SizedBox(height: 16),
                      Text("${imageKeys[4]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[4]),
                      SizedBox(height: 16),
                      Text("${imageKeys[5]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[5]),
                      SizedBox(height: 16),
                      Text("${imageKeys[6]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[6]),
                      SizedBox(height: 16),
                      Text("${imageKeys[7]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[7]),
                      SizedBox(height: 16),
                      Text("${imageKeys[8]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[8]),
                      SizedBox(height: 16),
                      Text("${imageKeys[9]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[9]),
                      SizedBox(height: 16),
                      Text("${imageKeys[10]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[10]),
                      SizedBox(height: 16),
                      Text("${imageKeys[11]}: "),
                      PreSiteImagePickerButton(title: "Upload Photo", imageKey: imageKeys[11]),
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
                String formatDate(DateTime date) {
                  int day = date.day;
                  int month = date.month;
                  int year = date.year;
                  return '$day-$month-$year';
                }
                _controller.uploadImageAndData("preSite", imageKeys, "PreSiteData", widget.taskId, formatDate(DateTime.now()));
              }, child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

}
