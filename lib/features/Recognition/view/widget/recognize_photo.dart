import 'package:face_recognition/features/Recognition/view/widget/face_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/recognize_image_cubit/recognize_image_cubit.dart';

class RecognizePhoto extends StatelessWidget {
  const RecognizePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecognizeImageCubit, RecognizeImageState>(
      builder: (context, state) {
        var cubit = RecognizeImageCubit.get(context);
        return cubit.image != null
            ? SizedBox(
                height: 300,
                child: FittedBox(
                  child: SizedBox(
                    width: cubit.image.width.toDouble(),
                    height: cubit.image.width.toDouble(),
                    child: CustomPaint(
                      painter: FacePainter(
                        faceList: cubit.recognitions,
                        imageFile: cubit.image,
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE06A39)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.no_photography,
                  size: 350,
                  color: Color(0xffE06A39),
                ),
              );
      },
    );
  }
}
