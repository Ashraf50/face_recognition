import 'package:face_recognition/core/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/widget/custom_button.dart';
import 'widget/face_painter.dart';
import 'dart:io';
import 'package:face_recognition/core/ML/Recognition.dart';
import 'package:face_recognition/core/ML/Recognizer.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  late FaceDetector faceDetector;
  late ImagePicker imagePicker;
  File? _image;
  dynamic croppedImage;
  late Recognizer recognizer;
  List<Face> faces = [];
  List<Recognition> recognitions = [];
  var image;

  Future<void> uploadImage(ImageSource cameraOrGallery) async {
    final pickedImg = await ImagePicker().pickImage(source: cameraOrGallery);
    try {
      if (pickedImg != null) {
        _image = File(pickedImg.path);
      } else {}
    } catch (e) {
      print("Error => $e");
    }
  }

  doFaceDetection() async {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(options: options);
    recognizer = Recognizer();
    recognitions.clear();

    //passing input to face detector and getting detected faces
    final InputImage inputImage;
    inputImage = InputImage.fromFile(_image!);

    //call the method to perform face recognition on detected faces
    faces = await faceDetector.processImage(inputImage);

    // Convert the image to Image format
    image = await decodeImageFromList(_image!.readAsBytesSync());

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print('Face Position = ${boundingBox.toString()}');
      // Cropping the face
      // 0- Get the needed variables
      final top = boundingBox.top < 0 ? 0 : boundingBox.top;
      final left = boundingBox.left < 0 ? 0 : boundingBox.left;
      final bottom = boundingBox.bottom > image.height
          ? image.height - 1
          : boundingBox.bottom;
      final right =
          boundingBox.right > image.width ? image.width - 1 : boundingBox.right;

      final width = right - left;
      final height = bottom - top;

      // 1- Convert image to IMG type
      final bytes = _image!.readAsBytesSync();
      img.Image? faceImage = img.decodeImage(bytes);
      // 2- Crop image
      final croppedFace = img.copyCrop(faceImage!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt());
      final recognition = recognizer.recognize(croppedFace, boundingBox);
      if (recognition.distance > 1.2) {
        recognition.name = "UnKnown";
      }
      recognitions.add(recognition);
    }
    drawRectangleAroundFaces();
  }

  drawRectangleAroundFaces() async {
    setState(() {
      image;
      recognitions;
    });
  }

  choosePhoto() async {
    await uploadImage(ImageSource.gallery);
    doFaceDetection();
  }

  takePhoto() async {
    await uploadImage(ImageSource.camera);
    doFaceDetection();
  }

  @override
  Widget build(BuildContext context) {
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
              image != null
                  ? SizedBox(
                      height: 300,
                      child: FittedBox(
                        child: SizedBox(
                          width: image.width.toDouble(),
                          height: image.width.toDouble(),
                          child: CustomPaint(
                            painter: FacePainter(
                              faceList: recognitions,
                              imageFile: image,
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
                    )
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              onPressed: () async {
                await choosePhoto();
              },
              icon: const Icon(
                Icons.photo,
              ),
            ),
            CustomButton(
              onPressed: () async {
                await takePhoto();
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
