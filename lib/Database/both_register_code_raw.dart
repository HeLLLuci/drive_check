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
  bool isPhoneRegistration = false;
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
                    profilePic != null ? Container() : Text("Upload profile picture"),
                    SizedBox(height: 20),
                    RegisterFields(controller: nameController, labelText: "Enter Name", type: TextInputType.name),
                    SizedBox(height: 10),
                    RegisterFields(controller: empIDController, labelText: "Enter Employee ID", type: TextInputType.text),
                    SizedBox(height: 10),
                    isPhoneRegistration
                        ? RegisterFields(controller: phoneController, labelText: "Enter Phone Number", type: TextInputType.phone)
                        : Column(
                      children: [
                        RegisterFields(controller: emailController, labelText: "Enter Email", type: TextInputType.emailAddress),
                        SizedBox(height: 10),
                        RegisterFields(controller: passwordController, labelText: "Enter Password", type: TextInputType.text),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: isObscure ? Text("Show password", style: TextStyle(color: Color(0xFF159757))) : Text("Hide password", style: TextStyle(color: Color(0xFF159757))),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    isLoading
                        ? CircularProgressIndicator(color: Color(0xFF159757))
                        : Button(
                      buttonText: "Register",
                      onTap: () {
                        if (profilePic != null) {
                          if (nameController.text.isEmpty || empIDController.text.isEmpty || (isPhoneRegistration ? phoneController.text.isEmpty : emailController.text.isEmpty || passwordController.text.isEmpty)) {
                            MotionToast.error(
                              title: Text("Oops!"),
                              description: Text("Each field is mandatory."),
                            ).show(context);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            if (isPhoneRegistration) {
                              registerWithPhoneNumber(phoneController.text);
                            } else {
                              registerUser(emailController.text, passwordController.text);
                            }
                          }
                        } else {
                          MotionToast.error(
                            title: Text("Oops!"),
                            description: Text("Please select a profile picture"),
                          ).show(context);
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                      },
                      child: Text(
                        "Already registered?",
                        style: TextStyle(
                          color: Color(0xFF159757),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ToggleButtons(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("Email")),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("Phone")),
                      ],
                      isSelected: [!isPhoneRegistration, isPhoneRegistration],
                      onPressed: (index) {
                        setState(() {
                          isPhoneRegistration = index == 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      // Check if the Employee ID is unique
      final empID = empIDController.text;
      bool empIDExists = await FirebaseFirestore.instance
          .collection('users')
          .where('Employee ID', isEqualTo: empID)
          .get()
          .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

      if (empIDExists) {
        throw Exception("Employee ID already exists.");
      }

      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      String? uid = userCredential.user?.uid;

      // Create a Firestore transaction to ensure the Employee ID is unique
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

        // Check again within the transaction to ensure the Employee ID is unique
        bool empIDExistsInTransaction = await FirebaseFirestore.instance
            .collection('users')
            .where('Employee ID', isEqualTo: empID)
            .get()
            .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

        if (empIDExistsInTransaction) {
          throw Exception("Employee ID already exists.");
        }

        // If the document doesn't exist, create it
        if (!(await transaction.get(userDocRef)).exists) {
          transaction.set(userDocRef, {});
        }

        // Set user details
        transaction.set(userDocRef, {
          'Employee Name': nameController.text,
          'Employee ID': empID,
          'Phone Number': phoneController.text,
          'Email': email,
          'Profile Picture': url,
        });
      });

      setState(() {
        isLoading = false;
      });
      MotionToast.success(
        title: Text("Success"),
        description: Text("You have registered successfully. You can now login."),
      ).show(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      MotionToast.error(
        title: Text("Oops!"),
        description: Text(e is Exception ? e.toString() : "Something went wrong. Please try again."),
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
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('profile_images').child('$name.jpg');
      await ref.putFile(File(pickedFile.path));
      return await ref.getDownloadURL();
    }
    return null;
  }

  void registerWithPhoneNumber(String phoneNumber) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
        UserCredential userCredential = await auth.signInWithCredential(credential);
        String? uid = userCredential.user?.uid;

        // Check if the Employee ID is unique
        final empID = empIDController.text;
        bool empIDExists = await FirebaseFirestore.instance
            .collection('users')
            .where('Employee ID', isEqualTo: empID)
            .get()
            .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

        if (empIDExists) {
          throw Exception("Employee ID already exists.");
        }

        // Create a Firestore transaction to ensure the Employee ID is unique
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

          // Check again within the transaction to ensure the Employee ID is unique
          bool empIDExistsInTransaction = await FirebaseFirestore.instance
              .collection('users')
              .where('Employee ID', isEqualTo: empID)
              .get()
              .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

          if (empIDExistsInTransaction) {
            throw Exception("Employee ID already exists.");
          }

          // If the document doesn't exist, create it
          if (!(await transaction.get(userDocRef)).exists) {
            transaction.set(userDocRef, {});
          }

          // Set user details
          transaction.set(userDocRef, {
            'Employee Name': nameController.text,
            'Employee ID': empID,
            'Phone Number': phoneController.text,
            'Email': null,
            'Profile Picture': url,
          });
        });

        setState(() {
          isLoading = false;
        });
        MotionToast.success(
          title: Text("Success"),
          description: Text("You have registered successfully. You can now login."),
        ).show(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
      };

      final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });
        MotionToast.error(
          title: Text("Oops!"),
          description: Text(e.message ?? "Something went wrong. Please try again."),
        ).show(context);
      };

      final PhoneCodeSent codeSent = (String verificationId, int? resendToken) async {
        // Show dialog to enter the verification code
        String? smsCode = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            String code = '';
            return AlertDialog(
              title: Text("Enter Verification Code"),
              content: TextField(
                onChanged: (value) {
                  code = value;
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Submit"),
                  onPressed: () {
                    Navigator.of(context).pop(code);
                  },
                ),
              ],
            );
          },
        );

        if (smsCode != null) {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          await PhoneVerificationCompleted;
        }
      };

      final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verificationId) {};

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout,
      );
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      MotionToast.error(
        title: Text("Oops!"),
        description: Text(e is Exception ? e.toString() : "Something went wrong. Please try again."),
      ).show(context);
    }
  }
}

