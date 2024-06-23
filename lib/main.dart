import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_check/Screens/login.dart';
import 'package:drive_check/Screens/on_site_data_screen.dart';
import 'package:drive_check/Screens/post_site_data_screen.dart';
import 'package:drive_check/Screens/pre_site_data_screen.dart';
import 'package:drive_check/Screens/update_availability.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Screens/homescreen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        primaryColor: Color(0xFF4FA457),
        primarySwatch: Colors.green,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: checkStat(snapshot.data!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return snapshot.data!;
              }
            },
          );
        } else {
          return Loginscreen();
        }
      },
    );
  }



  Future<Widget> checkStat(User user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String id = user.uid;
    DocumentSnapshot<Map<String, dynamic>> doc = await db.collection("users").doc(id).get();

    if (doc.exists && doc.data() != null) {
      String state = doc.data()!['state'] ?? 'unknown';
      switch(state){
        case 'preSite':
          return PreSiteData();

        case 'onSite':
          return OnSiteData();

        case 'postSite':
          return PostSiteData();

        default:
          return UpdateAvailability();
      }
    } else {
      return Loginscreen();
    }
  }
}

