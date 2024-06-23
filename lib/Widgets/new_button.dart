import 'package:flutter/material.dart';

class NewButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const NewButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFF159757),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        ),
      ),
    );
  }
}
