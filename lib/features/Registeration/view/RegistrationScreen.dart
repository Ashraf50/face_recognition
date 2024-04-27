import 'package:face_recognition/core/widget/custom_app_bar.dart';
import 'package:face_recognition/core/widget/custom_button.dart';
import 'package:face_recognition/features/Registeration/view/widget/register_photo.dart';
import 'package:face_recognition/features/Registeration/view_model/register_image_cubit/register_image_cubit.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = RegisterImageCubit.get(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              CustomAppBar(
                title: "Face Register",
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const RegisterPhoto(),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              onPressed: () async {
                await cubit.choosePhoto(context);
              },
              icon: const Icon(
                Icons.photo,
              ),
            ),
            CustomButton(
              onPressed: () async {
                await cubit.takePhoto(context);
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
