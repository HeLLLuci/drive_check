import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_check/Screens/PostSite/post_site_form.dart';
import 'package:drive_check/Screens/login.dart';
import 'package:drive_check/Screens/pre_site_form.dart';
import 'package:drive_check/Screens/update_availability.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lottie/lottie.dart';
import 'Screens/OnSite/on_site_form.dart';
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
          return showLoading();
        } else if (snapshot.hasData) {
          return FutureBuilder<Widget>(
            future: checkStat(snapshot.data!),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return showLoading();
              } else if (futureSnapshot.hasError) {
                return Center(child: Text('Error: ${futureSnapshot.error}'));
              } else {
                return futureSnapshot.data!;
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
      String taskId = doc.data()!['taskId'] ?? '';
      switch(state){
        case 'preSite':
          return PreSiteForm(taskId: taskId);

        case 'onSite':
          return OnSiteForm(taskId: taskId,);

        case 'postSite':
          return PostSiteForm(taskId: taskId);

        default:
          return UpdateAvailability();
      }
    } else {
      return Loginscreen();
    }
  }

  Widget showLoading() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          child: Lottie.asset("assets/Animations/loading.json"),
        ),
      ),
    );
  }
}
