import 'dart:io';
import 'package:face_recognition/core/ML/Recognition.dart';
import 'package:face_recognition/core/ML/Recognizer.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
part 'recognize_image_state.dart';

class RecognizeImageCubit extends Cubit<RecognizeImageState> {
  RecognizeImageCubit() : super(RecognizeImageInitial());

  static RecognizeImageCubit get(context) => BlocProvider.of(context);
  late FaceDetector faceDetector;
  late ImagePicker imagePicker;
  File? _image;
  dynamic croppedImage;
  late Recognizer recognizer;
  List<Face> faces = [];
  List<Recognition> recognitions = [];
  var image;

  choosePhoto() async {
    await uploadImage(ImageSource.gallery);
    doFaceDetection();
  }

  takePhoto() async {
    await uploadImage(ImageSource.camera);
    doFaceDetection();
  }

  Future<void> uploadImage(ImageSource cameraOrGallery) async {
    emit(RecognizeImageLoading());
    final pickedImg = await ImagePicker().pickImage(source: cameraOrGallery);
    try {
      if (pickedImg != null) {
        _image = File(pickedImg.path);
        emit(RecognizeImageSuccess());
      } else {
        emit(RecognizeImageFailure());
      }
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
    image;
    recognitions;
  }
}
