import 'package:face_recognition/core/widget/custom_app_bar.dart';
import 'package:face_recognition/features/Home/view/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../Recognition/view/RecognitionScreen.dart';
import '../../Registeration/view/RegistrationScreen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const CustomAppBar(
                    title: "Face Recognition",
                  ),
                  Lottie.asset(
                    "assets/logo.json",
                  ),
                ],
              ),
              Column(
                children: [
                  CustomButton(
                    title: "Register Face",
                    onTap: () {
                      Get.to(
                        () => const RegistrationScreen(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    title: "Recognize Face",
                    onTap: () {
                      Get.to(
                        () => const RecognitionScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
