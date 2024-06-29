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
  final List<String> imageKeys = ["Photo of power cable", "Site leaving selfie", "Photo of cab", "Cab driver's driving licence"];
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
          subtitle: Text("Fill the form to proceed"),
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
                      Row(
                        children: [
                          Text("Select Date: "),
                          InkWell(
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );
                              if (pickedDate != null && pickedDate != selectedDate) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  _controller.date.value = pickedDate.toString();
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                  : "Select Date"),
                            ),
                          ),
                        ],
                      ),
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
                      Text("Site ID: "),
                      TextFormField(
                        controller: _controller.siteIdController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Site ID',
                        ),
                      ),
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
                      Text("${imageKeys[0]}: "),
                      PostSiteImagePickerButton(title: imageKeys[0], imageKey: imageKeys[0]),
                      SizedBox(height: 16),
                      Text("${imageKeys[1]}: "),
                      PostSiteImagePickerButton(title: imageKeys[1], imageKey: imageKeys[1]),
                      SizedBox(height: 16),
                      Text("${imageKeys[2]}: "),
                      PostSiteImagePickerButton(title: imageKeys[2], imageKey: imageKeys[2]),
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
                      PostSiteImagePickerButton(title: imageKeys[3], imageKey: imageKeys[3]),
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
                      Text("KM reading after drive completion: "),
                      TextFormField(
                        controller: _controller.driveCompletionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter KM reading after drive completion',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Remarks (If Any): "),
                      TextFormField(
                        controller: _controller.remarksController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Enter Remarks',
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
            ],
          ),
        ),
      ),
    );
  }

}
