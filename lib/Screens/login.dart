import 'package:drive_check/Screens/homescreen.dart';
import 'package:drive_check/Screens/register.dart';
import 'package:drive_check/Widgets/Button.dart';
import 'package:drive_check/config/fontsstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';



class Loginscreen extends StatefulWidget {
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListTile(
            title: Text(
              "Login",
              style: FontStyles.titleTextStyle,
            ),
            subtitle: Text(
              "using your credentials",
              style: FontStyles.subtitleTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF159757),
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      labelText: "Enter Email",
                      floatingLabelStyle: TextStyle(color: Color(0xFF159757)),
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
                      floatingLabelStyle: TextStyle(color: Color(0xFF159757)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF159757),
                          ),
                          borderRadius: BorderRadius.circular(10))),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextButton(onPressed: (){
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                    child: isObscure ? Text("show password", style: TextStyle(color: Color(0xFF159757)),) : Text("hide password", style: TextStyle(color: Color(0xFF159757)),)
                ),
                SizedBox(
                  height: 20,
                ),
                isLoading ? CircularProgressIndicator(
                  color: Color(0xFF159757),
                ) : Button(
                    buttonText: "Login", onTap: (){
                      setState(() {
                        isLoading = true;
                      });
                      loginUser(emailController.text.trim(), passwordController.text.trim());
                }
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                    }, child: Text("Not registered yet ?",
                  style: TextStyle(
                    color: Color(0xFF159757),
                ),))
              ],
            ),
          ),
        ),
      ],
    ));
  }
  void loginUser(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Login Successful");
      emailController.clear();
      passwordController.clear();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homescreen()));
    }
    catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }
}
