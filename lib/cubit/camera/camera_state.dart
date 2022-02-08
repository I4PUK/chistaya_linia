part of 'camera_cubit.dart';

abstract class CameraState {
  const CameraState();
}

class Initial extends CameraState {
  const Initial();
}

class UploadingImage extends CameraState {
  const UploadingImage();
}

class UploadingImageSuccess extends CameraState {
  final PhotoInfo photo;
  const UploadingImageSuccess(this.photo);
}

class UploadingImageFailed extends CameraState {}
