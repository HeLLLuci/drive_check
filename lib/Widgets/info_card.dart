import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Widget> guidelineList= [
      GuideLine(imagePath: "assets/Images/guidelines/1.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/2.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/3.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/4.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/5.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/6.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/7.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/8.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/9.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/10.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/11.jpg"),
      GuideLine(imagePath: "assets/Images/guidelines/12.jpg")
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
          color: Color(0xFFF4F8F6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 4),
            blurRadius: 10
          )
        ]
      ),
      child: CarouselSlider(
          items: guidelineList,
          options: CarouselOptions(
          enableInfiniteScroll: true,
          autoPlayCurve: Curves.decelerate,
          autoPlay: true,
          viewportFraction: 1,
          initialPage: 0
        ),
      ),
    );
  }
}

class GuideLine extends StatelessWidget {

  final String imagePath;

  const GuideLine({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(imagePath,fit: BoxFit.scaleDown,height: 150,)),
      ],
    );
  }
}

