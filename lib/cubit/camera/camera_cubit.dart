import 'package:camera/camera.dart';
import 'package:chistaya_linia_test/models/photo_info.dart';
import 'package:chistaya_linia_test/services/dio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final DioService dioService = DioService();

  CameraCubit(initialState) : super(initialState);

  dynamic postImage(String path) async {
    final result = await dioService.uploadPhotosWithPath(path);
    result.url != null
        ? emit(UploadingImageSuccess(result))
        : emit(UploadingImageFailed());
  }

  Future<XFile?> takePicture(CameraController controller) async {
    if (controller.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await controller.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }
}
