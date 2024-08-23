import 'package:drive_check/New%20Code/Components/Buttons/login_button.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:drive_check/New%20Code/Model/task.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final TaskModel data;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  const TaskCard({super.key, required this.data, required this.onAccept, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Site ID: ${data.siteID}"),
          SizedBox(height: 2.h,),
          Text("Allocated Date: ${data.allocatedDate}"),
          SizedBox(height: 2.h,),
          Text("Assigned To: ${data.employeeName}"),
          SizedBox(height: 2.h,),
          Text("Lat, Long: ${data.latitude}, ${data.longitude}"),
          SizedBox(height: 2.h,),
          LoginButton(title: "Accept", onTap: onAccept),
          SizedBox(height: 2.h,),
          LoginButton(title: "Reject", onTap: onReject),
        ],
      ),
    );
  }
}
