import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const LoginButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15.w
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: loginButtonColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        height: 7.h,
        child: Text(title, style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 2.4.t,
          fontWeight: FontWeight.w500
        ),),
      ),
    );
  }
}
