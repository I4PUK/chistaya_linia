import 'dart:convert';

import 'package:chistaya_linia_test/models/photo_info.dart';
import 'package:chistaya_linia_test/services/api_router.dart';
import 'package:dio/dio.dart';

class DioService {
  Future<PhotoInfo> uploadPhotosWithPath(String path) async {
    MultipartFile file = await MultipartFile.fromFile(path);
    var formData = FormData.fromMap({'key': APIRouter.apiKey, 'image': file});

    final Response<String> response =
        await Dio().post(APIRouter.uploadRoute, data: formData);
    return PhotoInfo.fromJson(json.decode(response.data!));
  }
}
