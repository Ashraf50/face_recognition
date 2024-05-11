import 'package:face_recognition/core/widget/custom_app_bar.dart';
import 'package:face_recognition/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:face_recognition/core/ML/Recognition.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ML/Recognizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late FaceDetector faceDetector;
  late ImagePicker imagePicker;
  File? _image;
  late Recognizer recognizer;
  List<Face> faces = [];
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

  doFaceDetection(BuildContext context) async {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(options: options);
    recognizer = Recognizer();
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
      Recognition recognition = recognizer.recognize(croppedFace, boundingBox);
      // ignore: use_build_context_synchronously
      showFaceRegistrationDialogue(
        context,
        Uint8List.fromList(img.encodeBmp(croppedFace)),
        recognition,
      );
    }
    drawRectangleAroundFaces();
  }

  drawRectangleAroundFaces() async {
    setState(() {
      image;
      faces;
    });
  }

  choosePhoto(BuildContext context) async {
    await uploadImage(ImageSource.gallery);
    // ignore: use_build_context_synchronously
    doFaceDetection(context);
  }

  takePhoto(BuildContext context) async {
    await uploadImage(ImageSource.camera);
    // ignore: use_build_context_synchronously
    doFaceDetection(context);
  }

  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(
      BuildContext context, Uint8List cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter Name",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  recognizer.registerFaceInDB(
                    textEditingController.text,
                    recognition.embeddings,
                  );
                  textEditingController.text = "";
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Face Registered"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(200, 40),
                ),
                child: const Text("Register"),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
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
                title: "Face Register",
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
                              facesList: faces,
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
                await choosePhoto(context);
              },
              icon: const Icon(
                Icons.photo,
              ),
            ),
            CustomButton(
              onPressed: () async {
                await takePhoto(context);
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
