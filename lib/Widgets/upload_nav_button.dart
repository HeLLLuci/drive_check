import 'package:flutter/material.dart';

class UploadNavButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;
  const UploadNavButton({super.key, required this.buttonTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF2ABC6B),
            Color(0xFF4DD281),
          ],
          begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          buttonTitle,
          style: TextStyle(
              color: Colors.white,
              fontSize: 15
          ),
        ),
      ),
    );
  }
}
