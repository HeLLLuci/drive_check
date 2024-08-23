import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvailabilityButton extends StatelessWidget {
  final String status;
  final VoidCallback onTap;
  const AvailabilityButton({super.key, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(2.h),
        height: 20.h,
        width: 40.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          color: Colors.white,
        ),
        child: Text(
            "Click here if,\nYou are\n${status}\nfor Work",
          style: GoogleFonts.poppins(
            fontSize: 2.4.t,
            color: Colors.black,
            fontWeight: FontWeight.w300
          ),
        ),
      ),
    );
  }
}
