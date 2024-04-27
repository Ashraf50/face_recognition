part of 'register_image_cubit.dart';

@immutable
sealed class RegisterImageState {}

final class RegisterImageInitial extends RegisterImageState {}

final class RegisterImageLoading extends RegisterImageState {}

final class RegisterImageSuccess extends RegisterImageState {}

final class RegisterImageFailure extends RegisterImageState {}
