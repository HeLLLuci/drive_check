import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_check/Widgets/text_fields.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:drive_check/Screens/login.dart';
import 'package:drive_check/Widgets/Button.dart';
import 'package:drive_check/config/fontsstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController empIDController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? url;
  bool isObscure = true;
  bool isLoading = false;
  File? profilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
      ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ListTile(
                  title: Text(
                    "Register",
                    style: FontStyles.titleTextStyle,
                  ),
                  subtitle: Text(
                    "if you are new to app",
                    style: FontStyles.subtitleTextStyle,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (nameController.text.trim().isEmpty) {
                            MotionToast.error(
                              title: Text("Oops!"),
                              description: Text("Please enter your name first."),
                            ).show(context);
                            return;
                          }
                          String? imageUrl = await uploadImage(nameController.text.trim());
                          if (imageUrl != null) {
                            setState(() {
                              url = imageUrl;
                            });
                          }
                        },
                        child: profilePic != null
                            ? CircleAvatar(
                          backgroundColor: Color(0xFFECF7ED),
                          radius: 40,
                          backgroundImage: FileImage(profilePic!), // Display picked image
                        )
                            : CircleAvatar(
                          backgroundColor: Color(0xFFECF7ED),
                          radius: 50,
                          child: Icon(Icons.add_photo_alternate_rounded, size: 40, color: Color(0xFF449C4C)),
                        ),
                      ),
                      profilePic!=null ? Container() : Text("Upload profile picture"),
                      SizedBox(
                        height: 20,
                      ),
                      RegisterFields(controller: nameController, labelText: "Enter Name"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: empIDController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Enter Employee ID",
                            floatingLabelStyle: TextStyle(
                                color: Color(0xFF159757)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10))),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Enter Phone Number",
                            floatingLabelStyle: TextStyle(
                                color: Color(0xFF159757)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10))),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Enter Email",
                            floatingLabelStyle: TextStyle(
                                color: Color(0xFF159757)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10))),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isObscure,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Enter Password",
                            floatingLabelStyle: TextStyle(
                                color: Color(0xFF159757)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF159757),
                                ),
                                borderRadius: BorderRadius.circular(10))),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextButton(onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                          child: isObscure ? Text("show password",
                            style: TextStyle(color: Color(0xFF159757)),) : Text(
                            "hide password",
                            style: TextStyle(color: Color(0xFF159757)),)
                      ),
                      isLoading ? CircularProgressIndicator(
                        color: Color(0xFF159757),
                      ) : Button(
                          buttonText: "Register", onTap: () {
                        if(profilePic!=null){
                          if(nameController.text.isEmpty||emailController.text.isEmpty||phoneController.text.isEmpty||empIDController.text.isEmpty||passwordController.text.isEmpty){
                            MotionToast.error(
                                title: Text("Oops!"),
                                description: Text("Each field is mandatory.")
                            ).show(context);
                          }
                          else{
                            setState(() {
                              isLoading = true;
                            });
                            registerUser(
                                emailController.text, passwordController.text);
                          }
                        }
                        else{
                          MotionToast.error(
                          title: Text("Oops!"),
                          description: Text("Please select profile picture")
                          ).show(context);
                        }
                      }
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Loginscreen()));
                          }, child: Text("Already registered ?",
                        style: TextStyle(
                          color: Color(0xFF159757),
                        ),))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void registerUser(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? uid = userCredential.user?.uid;
      bool collectionExists = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((docSnapshot) => docSnapshot.exists);
      if (!collectionExists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({});
      }
      if (url != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'Employee Name': nameController.text,
          'Employee ID': empIDController.text,
          'Phone Number': phoneController.text,
          'Email': emailController.text,
          'Profile Picture': url,
        });
      }

      setState(() {
        isLoading = false;
      });
      MotionToast.success(
        title: Text("Success"),
        description: Text("You have registered successfully. You can now login."),
      ).show(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginscreen()));
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      MotionToast.error(
          title: Text("Oops!"),
          description: Text("Something went wrong. Please try again.")
      ).show(context);
    }
  }

  Future<String?> uploadImage(String name) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profilePic = File(pickedFile.path);
      });
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$name.jpg');
      await ref.putFile(File(pickedFile.path));
      return await ref.getDownloadURL();
    }
    return null;
  }
}
