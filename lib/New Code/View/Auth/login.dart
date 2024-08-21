import 'package:drive_check/New%20Code/Components/Buttons/login_button.dart';
import 'package:drive_check/New%20Code/Components/login_input.dart';
import 'package:drive_check/New%20Code/Controller/auth_controller.dart';
import 'package:drive_check/New%20Code/Helper/colors.dart';
import 'package:drive_check/New%20Code/Helper/paths.dart';
import 'package:drive_check/New%20Code/Helper/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 7.w,
        ),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 4.0.h,
              ),
              Text(
                "DriveCheck",
                style:
                    GoogleFonts.pacifico(color: Colors.white, fontSize: 4.0.t),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.0.h,
              ),
              SvgPicture.asset(loginIcon),
              Text(
                "Login",
                style:
                    GoogleFonts.poppins(fontSize: 2.4.t, color: Colors.white),
              ),
              SizedBox(
                height: 3.0.h,
              ),
              LoginInput(
                  controller: controller.emailController,
                  labelText: "Enter Email",
                  KeyboardType: TextInputType.emailAddress),
              SizedBox(
                height: 1.5.h,
              ),
              Obx(() => LoginInput(
                    controller: controller.passwordController,
                    labelText: "Enter password",
                    KeyboardType: TextInputType.visiblePassword,
                    suffixIcon: controller.obscureText.value
                        ? GestureDetector(
                            onTap: () => controller.obscureText.value = false,
                            child: Icon(
                              Icons.visibility_rounded,
                              color: Colors.white,
                            ))
                        : GestureDetector(
                            onTap: () => controller.obscureText.value = true,
                            child: Icon(
                              Icons.visibility_off_rounded,
                              color: Colors.white,
                            )),
                    obscureText: controller.obscureText.value,
                  )),
              SizedBox(
                height: 4.0.h,
              ),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: loginButtonColor,
                      ),
                    )
                  : LoginButton(
                      title: "Login",
                      onTap: () async {
                        controller.isLoading.value = true;
                        await controller.loginUser();
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
