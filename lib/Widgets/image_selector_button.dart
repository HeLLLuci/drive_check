import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ImagePickerButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Color(0xFFECF7ED),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [Image.asset("assets/Images/addimage.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Color(0xFF449C4C)),
                  ),
                ),
                Icon(Icons.cloud_upload, color: Color(0xFF449C4C),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
