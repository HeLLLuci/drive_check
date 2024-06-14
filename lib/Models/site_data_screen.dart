import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:slider_button/slider_button.dart';
import 'package:drive_check/Widgets/image_picker_button.dart';
import 'package:drive_check/Widgets/text_fields.dart';
import 'package:drive_check/config/fontsstyles.dart';

import '../controller/site_data_controller.dart';

class SiteDataScreen extends StatelessWidget {
  final String step;
  final String siteType;
  final String collectionName;
  final List<String> imageKeys;

  const SiteDataScreen({
    Key? key,
    required this.step,
    required this.siteType,
    required this.collectionName,
    required this.imageKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SiteDataController());
    controller.siteTime.value = siteType;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Text(
            "Data Screen $step/3",
            style: TextStyle(color: Color(0xFF449C4C)),
          ),
          SizedBox(width: 30)
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          ListTile(
            title: Text("Upload info $siteType", style: FontStyles.subtitleTextStyle),
            subtitle: Text("Supporting Data", style: FontStyles.titleTextStyle),
          ),
          SizedBox(height: 40),
          TextFields(
              labelText: "Site ID", controller: controller.siteIdController, enabled: true),
          SizedBox(height: 10),
          TextFields(
              labelText: "Employee ID", controller: controller.empIdController, enabled: false),
          SizedBox(height: 30),
          ...imageKeys.map((key) => Column(
            children: [
              ImagePickerButton(title: "Photo of $key", imageKey: key),
              SizedBox(height: 10),
            ],
          )),
          SizedBox(height: 20),
          Obx(() {
            return controller.isLoading.value
                ? LoadingAnimationWidget.fourRotatingDots(color: Color(0xFF449C4C), size: 30)
                : SliderButton(
              buttonSize: 60,
              action: () async {
                controller.siteId.value = controller.siteIdController.text;
                await controller.uploadImageAndData(siteType, imageKeys, collectionName);
                return false;
              },
              label: Text(
                "Slide to submit data",
                style: TextStyle(
                    color: Color(0xff4a4a4a), fontWeight: FontWeight.w500, fontSize: 17),
              ),
              icon: Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF449C4C)),
            );
          }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
