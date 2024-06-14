import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/site_data_controller.dart';

class ImagePickerButton extends StatelessWidget {
  final String title;
  final String imageKey;
  const ImagePickerButton({Key? key, required this.title, required this.imageKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SiteDataController>();

    return Obx(() {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () => controller.pickImage(imageKey),
            child: Text(title),
          ),
          if (controller.images[imageKey] != null)
            Image.file(controller.images[imageKey]!, height: 100, width: 100),
        ],
      );
    });
  }
}
