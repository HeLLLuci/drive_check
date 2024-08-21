import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType KeyboardType;
  final Widget? suffixIcon;
  final bool? obscureText;
  const LoginInput({super.key, required this.controller, required this.labelText, required this.KeyboardType, this.obscureText, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: KeyboardType,
      controller: controller,
      obscureText: obscureText!=null ? obscureText! : false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          color: Colors.white
        ),
        fillColor: fillColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide.none
        ),
        suffix: suffixIcon!=null ? suffixIcon : null,
      ),
    );
  }
}
