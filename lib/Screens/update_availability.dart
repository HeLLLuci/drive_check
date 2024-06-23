import 'package:drive_check/Screens/Tasks/my_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/update_availability_controller.dart';

class UpdateAvailability extends StatelessWidget {
  final UpdateAvailabilityController controller = Get.put(UpdateAvailabilityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DriveCheck"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Update Availability", style: TextStyle(fontSize: 25)),
            subtitle: Text(
              "You have to specify genuine reason to mark your unavailability. Admin will verify the reason.",
              style: TextStyle(fontSize: 10),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async{
                    await controller.updateAvailability("Available", "").then((_) {
                      Get.to(() => MyTask());
                    });
                  },
                  child: Text("Available")),
              ElevatedButton(
                  onPressed: () {
                    controller.handleNo(context);
                  },
                  child: Text("Not Available")),
            ],
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return CircularProgressIndicator();
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
