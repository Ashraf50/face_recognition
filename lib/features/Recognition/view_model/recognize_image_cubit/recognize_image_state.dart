part of 'recognize_image_cubit.dart';

sealed class RecognizeImageState {}

final class RecognizeImageInitial extends RecognizeImageState {}

final class RecognizeImageLoading extends RecognizeImageState {}

final class RecognizeImageSuccess extends RecognizeImageState {}

final class RecognizeImageFailure extends RecognizeImageState {}