import 'package:flutter/material.dart';
import '../Models/site_data_screen.dart';

class OnSiteData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteDataScreen(
      step: '2',
      siteType: 'OnSite',
      collectionName: 'onTestData',
      imageKeys: ['Selfie on site', 'wearing PPE kit', 'POD', 'All document', 'Full tower', 'Site in wide angle', 'OHS Status screenshot', 'PTW screenshot', 'Full team wearing PPE kit', 'TBT', 'all equipment & material', 'Entire tower', 'material required', 'installation done'],
    );
  }
}

