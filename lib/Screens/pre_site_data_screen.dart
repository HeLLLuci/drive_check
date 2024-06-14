import 'package:flutter/material.dart';
import '../Models/site_data_screen.dart';

class PreSiteData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteDataScreen(
      step: '1',
      siteType: 'PreSite',
      collectionName: 'preTestData',
      imageKeys: ['pole', 'odf', 'joint'],
    );
  }
}

