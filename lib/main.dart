import 'package:face_recognition/features/Registeration/view_model/register_image_cubit/register_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'features/Home/view/home_view.dart';
import 'features/Recognition/view_model/recognize_image_cubit/recognize_image_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecognizeImageCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterImageCubit(),
        ),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}
