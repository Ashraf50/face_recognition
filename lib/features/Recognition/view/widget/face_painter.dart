import 'package:face_recognition/core/ML/Recognition.dart';
import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  List<Recognition> faceList;
  dynamic imageFile;
  FacePainter({
    required this.faceList,
    @required this.imageFile,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 10;
    for (Recognition face in faceList) {
      canvas.drawRect(face.location, p);
      TextSpan textSpan = TextSpan(
        text: face.name,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          face.location.top + 120,
          face.location.top + -80,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
