import 'package:flutter/material.dart';
import '../Models/site_data_screen.dart';

class OnSiteData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteDataScreen(
      step: '2',
      siteType: 'OnSite',
      collectionName: 'onTestData',
      imageKeys: ['pole', 'odf', 'joint'],
    );
  }
}

