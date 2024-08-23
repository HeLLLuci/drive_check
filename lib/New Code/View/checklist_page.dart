import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:drive_check/New%20Code/Components/Buttons/login_button.dart';
import 'package:drive_check/New%20Code/Controller/task_controller.dart';
import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/task.dart';

class ChecklistPage extends StatelessWidget {
  final TaskModel task;
  ChecklistPage({super.key, required this.task});

  final TaskController controller = Get.find<TaskController>();

  final List<String> activityTypes = ['RF', 'TI'];
  final List<String> workTypes = ['DT+DT', 'DT+R', 'R+R'];
  final List<String> vehicleTypes = ['Commercial Cab', 'Private Cab', 'Public Transport'];
  final List<String> activityPlan = ['Yes', 'No'];
  final List<String> scopeOfWork = ['11 B', 'CLOT', 'SCFT', 'SSCVT'];
  final List<String> circles = [
    'MH',
    'GUJ',
    'BR',
    'JH',
    'ROB',
    'UPE',
    'UPW',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.h,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text("Before you move forward"),
            subtitle: Text("Fill some data here"),
          ),
          SizedBox(height: 5.h),
          Text("Is this activity planned at night"),
          Obx(() => CustomDropdown<String>(
            hintText: 'Select yes or no',
            items: activityPlan,
            initialItem: controller.activityAtNight.value,
            onChanged: (value) {
              controller.activityAtNight.value = value!;
            },
          )),
          SizedBox(height: 2.h),
          Text("Select Activity Type"),
          Obx(() => CustomDropdown<String>(
            hintText: 'Select options',
            items: activityTypes,
            initialItem: controller.activityType.value.isEmpty
                ? activityTypes[0]
                : controller.activityType.value,
            onChanged: (value) {
              controller.activityType.value = value!;
            },
          )),
          SizedBox(height: 2.h),
          Obx(()=> controller.activityType.value == 'RF' ? Text("Select work type") : Container()),
          Obx(() => controller.activityType.value == 'RF' ? CustomDropdown<String>(
            hintText: 'Select options',
            items: workTypes,
            initialItem: controller.workType.value.isEmpty
                ? workTypes[0]
                : controller.workType.value,
            onChanged: (value) {
              controller.workType.value = value!;
            },
          ) : Container()),
          SizedBox(height: 2.h),
          Text("Select vehicle type"),
          Obx(() => CustomDropdown<String>(
            hintText: 'Select Option',
            items: vehicleTypes,
            initialItem: controller.vehicleType.value.isEmpty
                ? vehicleTypes[0]
                : controller.vehicleType.value,
            onChanged: (value) {
              controller.vehicleType.value = value!;
            },
          )),
          SizedBox(height: 2.h),
          Text("Select Circle"),
          Obx(() => CustomDropdown<String>(
            hintText: 'Select options',
            items: circles,
            initialItem: controller.circle.value.isEmpty
                ? circles[0]
                : controller.circle.value,
            onChanged: (value) {
              controller.circle.value = value!;
            },
          )),
          SizedBox(height: 2.h),
          Obx(() => DataTable(
            columnSpacing: 45.w,
            columns: [
              DataColumn(label: Text('Image Name')),
              DataColumn(label: Text('Check')),
            ],
            rows: controller.images.map((image) {
              return DataRow(
                cells: [
                  DataCell(Text(image['imageName'])),
                  DataCell(
                    Checkbox(
                      value: image['checked'],
                      onChanged: (bool? value) {
                        image['checked'] = value;
                        controller.images.refresh(); // Notify GetX of the update
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          )),
          SizedBox(height: 2.h),
          Obx(()=> controller.loading.value ? Center(child: CircularProgressIndicator(color: loginButtonColor,)) :
              LoginButton(
              title: "Submit",
              onTap: () {
                controller.loading.value = true;
                controller.submitChecklist(task.documentID, task);
              }
          ),),
        ],
      ),
    );
  }
}


