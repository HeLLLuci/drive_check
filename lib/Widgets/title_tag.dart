import 'package:flutter/material.dart';

class TitleTag extends StatelessWidget {
  final String tagTitle;
  const TitleTag({super.key, required this.tagTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 80),
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(4, 4),
            blurRadius: 10
          )
        ],
          color: Color(0xFF159757),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Text(
        tagTitle,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20
        ),
      ),
    );
  }
}
