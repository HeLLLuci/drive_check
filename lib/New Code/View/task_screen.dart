import 'package:drive_check/New%20Code/Components/Cards/task_card.dart';
import 'package:drive_check/New%20Code/Controller/task_controller.dart';
import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Components/Buttons/login_button.dart';
import '../Model/task.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});
  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: Obx(() {
        // Check the loading state
        if (controller.tasks.isEmpty) {
          // Show a loading spinner or a message if no data is available
          return Center(
            child: controller.isLoading.value
                ? CircularProgressIndicator() // Show loader while fetching data
                : Text(
              'No data available for you',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 3.h,
            ),
            ListTile(
              title: Text("Good!, as you are available now"),
              subtitle: Text("Here are your tasks for today"),
            ),
            Expanded(child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 3.h
              ),
              itemCount: controller.tasks.length,
              itemBuilder: (context, index) {
                final TaskModel data = controller.tasks[index];
                return TaskCard(
                  data: data,
                  onAccept: () {
                    controller.acceptTask(data);
                  },
                  onReject: () {
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: controller.reasonController,
                              decoration: InputDecoration(
                                  labelText: "Enter Reason",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            LoginButton(title: "send", onTap: (){controller.rejectTask(data);Navigator.pop(context);})
                          ],
                        ),
                      );
                    });
                  },
                );
              },
            ))
          ],
        );
      }),
    );
  }
}
