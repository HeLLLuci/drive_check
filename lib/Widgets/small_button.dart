import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const SmallButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFF159757),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white,
          ),
        ),
      ),
    );
  }
}
