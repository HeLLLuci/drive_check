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

    // return Obx(() {
    //   return Column(
    //     children: [
    //       ElevatedButton(
    //         onPressed: () => controller.pickImage(imageKey),
    //         child: Text(title),
    //       ),
    //       if (controller.images[imageKey] != null)
    //         Image.file(controller.images[imageKey]!, height: 100, width: 100),
    //     ],
    //   );
    // });

    return Obx((){
      return GestureDetector(
        onTap: ()=> controller.pickImage(imageKey),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFECF7ED),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [Image.asset("assets/Images/addimage.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 16, color: Color(0xFF449C4C)),
                    ),
                  ),
                  Icon(Icons.cloud_upload, color: Color(0xFF449C4C),)
                ],
              ),
            ),
            if (controller.images[imageKey] != null)
                    Image.file(controller.images[imageKey]!, height: 100, width: 100),
          ],
        ),
      );
    });
  }
}
