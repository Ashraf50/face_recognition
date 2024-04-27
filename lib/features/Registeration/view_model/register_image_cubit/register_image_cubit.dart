import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:face_recognition/core/ML/Recognition.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ML/Recognizer.dart';
part 'register_image_state.dart';

class RegisterImageCubit extends Cubit<RegisterImageState> {
  RegisterImageCubit() : super(RegisterImageInitial());
  static RegisterImageCubit get(context) => BlocProvider.of(context);
  late FaceDetector faceDetector;
  late ImagePicker imagePicker;
  File? _image;
  late Recognizer recognizer;
  List<Face> faces = [];
  var image;

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

  Future<void> uploadImage(ImageSource cameraOrGallery) async {
    emit(RegisterImageLoading());
    final pickedImg = await ImagePicker().pickImage(source: cameraOrGallery);
    try {
      if (pickedImg != null) {
        _image = File(pickedImg.path);
        emit(RegisterImageSuccess());
      } else {
        emit(RegisterImageFailure());
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  doFaceDetection(BuildContext context) async {
    //TODO remove rotation of camera images
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    );
    faceDetector = FaceDetector(options: options);
    //TODO initialize face recognizer
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
    image;
    faces;
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
}
