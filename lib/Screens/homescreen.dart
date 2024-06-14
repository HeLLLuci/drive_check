import 'package:drive_check/Screens/login.dart';
import 'package:drive_check/Screens/post_site_data_screen.dart';
import 'package:drive_check/Screens/pre_site_data_screen.dart';
import 'package:drive_check/Widgets/info_card.dart';
import 'package:drive_check/Widgets/title_tag.dart';
import 'package:drive_check/Widgets/upload_nav_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import '../Database/get_employee_data.dart';
import 'on_site_data_screen.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String employeeName = '';
  String employeeId = '';
  String profileUrl = '';
  @override
  void initState() {
    super.initState();
    _fetchAndSetEmployeeID();
  }

  Future<void> _fetchAndSetEmployeeID() async {
    Map<String, dynamic> userData = await FirestoreService.fetchUserData();
    String empName = userData['Employee Name'] ?? '';
    String pUrl = userData['Profile Picture'] ?? '';
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        employeeName = empName;
        profileUrl = pUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/Images/HomescreenBackground.png"), fit: BoxFit.cover)
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(onTap: (){
            _scaffoldKey.currentState!.openDrawer();
          }, child: Image.asset("assets/Images/MenubarIcon.png")),
        ),
        drawer: Drawer(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hey $employeeName !", style: TextStyle(fontSize: 20),),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileUrl),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: (){
                    MotionToast.info(
                        title: Text("Hold on!"),
                        description: Text("We are working on this feature")
                    ).show(context);
                  },
                  leading: Icon(Icons.person),
                  title: Text("My Profile"),
                ),

                ListTile(
                  onTap: (){
                    MotionToast.info(
                        title: Text("Hold on!"),
                        description: Text("We are working on this feature")
                    ).show(context);
                  },
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),

                ListTile(
                  onTap: (){
                    auth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
                  },
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),

                ListTile(
                  onTap: (){
                    MotionToast.info(
                        title: Text("Hold on!"),
                        description: Text("We are working on this feature")
                    ).show(context);
                  },
                  leading: Icon(Icons.phone),
                  title: Text("Contact Us"),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleTag(tagTitle: "DriveCheck"),
              SizedBox(
                height: 100,
              ),
              InfoCard(),
              SizedBox(
                height: 30,
              ),
              Row(children: [SizedBox(width: 30,),Text("Uplaod Data"), SizedBox(width: 5,),Icon(Icons.arrow_forward_ios_outlined)],),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UploadNavButton(buttonTitle: "Before Site >", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PreSiteData()));
                }),
                UploadNavButton(buttonTitle: "On-Site >", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OnSiteData()));
                }),
                UploadNavButton(buttonTitle: "After Site >", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PostSiteData()));
                }),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
