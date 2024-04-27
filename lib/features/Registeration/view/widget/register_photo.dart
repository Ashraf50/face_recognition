import 'package:face_recognition/features/Registeration/view_model/register_image_cubit/register_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class RegisterPhoto extends StatelessWidget {
  const RegisterPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterImageCubit, RegisterImageState>(
      builder: (context, state) {
        var cubit = RegisterImageCubit.get(context);
        return cubit.image != null
            ? SizedBox(
                height: 300,
                child: FittedBox(
                  child: SizedBox(
                    width: cubit.image.width.toDouble(),
                    height: cubit.image.width.toDouble(),
                    child: CustomPaint(
                      painter: FacePainter(
                        facesList: cubit.faces,
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

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 10;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
