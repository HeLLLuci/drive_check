import 'package:flutter/material.dart';
import '../Models/site_data_screen.dart';

class PreSiteData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteDataScreen(
      step: '1',
      siteType: 'PreSite',
      collectionName: 'preTestData',
      imageKeys: ['Selfie in Room','All PPE kit Equipments', 'Handset with holder', 'Selfie With Cab', 'odometer', 'Inside Cab', 'Outside cab', 'No. plate of cab', 'Full cab', 'Insurance Documents', 'RC', 'Driving License'],
    );
  }
}

