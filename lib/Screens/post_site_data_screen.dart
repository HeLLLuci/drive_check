import 'package:flutter/material.dart';
import '../Models/site_data_screen.dart';

class PostSiteData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteDataScreen(
      step: '3',
      siteType: 'PostSite',
      collectionName: 'postTestData',
      imageKeys: ['power cable', 'Power cable readings', 'Site leaving selfie', 'cab', 'cab driver DL', 'RC with full cab'],
    );
  }
}
