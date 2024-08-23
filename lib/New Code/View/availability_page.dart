import 'package:cached_network_image/cached_network_image.dart';
import 'package:drive_check/New%20Code/Components/Buttons/availability_button.dart';
import 'package:drive_check/New%20Code/Components/Buttons/login_button.dart';
import 'package:drive_check/New%20Code/Controller/auth_controller.dart';
import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Helper/utils.dart';

class AvailabilityPage extends StatelessWidget {
  AvailabilityPage({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    return Scaffold(
      backgroundColor: greyColor,
      body: Padding(
        padding: horizontalPadding,
        child: ListView(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: backgroundColor.withOpacity(0.5),
                  child: user?.profilePicture != null && user!.profilePicture!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: user.profilePicture!,
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 25.0,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  )
                      : CircleAvatar(
                    radius: 25.0, // Adjust size as needed
                    backgroundColor: backgroundColor.withOpacity(0.5),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                title: Text(
                  "Welcome, ${user?.employeeName.split(' ')[0] ?? 'User'}!",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("to DriveCheck"),),
            SizedBox(
              height: 3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvailabilityButton(status: 'Available', onTap: () {
                  controller.updateAvailability(true, '');
                },),
                AvailabilityButton(status: 'Not Available', onTap: () {
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
                          LoginButton(title: "send", onTap: (){controller.updateAvailability(false, controller.reasonController.text.trim());Navigator.pop(context);})
                        ],
                      ),
                    );
                  });
                },),
              ],
            )
          ],
        ),
      ),
    );
  }
}
