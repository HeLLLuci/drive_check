import 'package:flutter/material.dart';
import '../Models/site_data_screen.dart';

class PostSiteData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteDataScreen(
      step: '3',
      siteType: 'PostSite',
      collectionName: 'postTestData',
      imageKeys: ['powerCable', 'siteLeaving', 'cabPhoto', 'cabDriverDL', 'RCcab'],
    );
  }
}
