import 'package:face_recognition/core/widget/custom_app_bar.dart';
import 'package:face_recognition/features/Recognition/view/widget/recognize_photo.dart';
import 'package:flutter/material.dart';
import '../view_model/recognize_image_cubit/recognize_image_cubit.dart';
import '../../../core/widget/custom_button.dart';

class RecognitionScreen extends StatelessWidget {
  const RecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = RecognizeImageCubit.get(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              CustomAppBar(
                title: "Face Recognize",
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const RecognizePhoto(),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              onPressed: () async {
                await cubit.choosePhoto();
              },
              icon: const Icon(
                Icons.photo,
              ),
            ),
            CustomButton(
              onPressed: () async {
                await cubit.takePhoto();
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
