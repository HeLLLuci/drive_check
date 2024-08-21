import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:drive_check/New%20Code/Helper/utils.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatelessWidget {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: Padding(
          padding: horizontalPadding,
        child: ListView(
          children: [
            SizedBox(
              height: 7.0.h,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0.0),
              title: Text("Welcome!"),
              subtitle: Text("to DriveCheck"),
            ),

          ],
        ),
      ),
    );
  }
}
