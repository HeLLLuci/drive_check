import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enabled;
  TextFields({super.key, required this.labelText, required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF159757),
              ),
              borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          floatingLabelStyle: TextStyle(color: Color(0xFF159757)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF159757),
              ),
              borderRadius: BorderRadius.circular(10))),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class RegisterFields extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const RegisterFields({super.key, required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF159757),
              ),
              borderRadius: BorderRadius.circular(10)),
          labelText: "Enter Full Name",
          floatingLabelStyle: TextStyle(
              color: Color(0xFF159757)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF159757),
              ),
              borderRadius: BorderRadius.circular(10))),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

