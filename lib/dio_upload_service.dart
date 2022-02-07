import 'package:dio/dio.dart';

class DioUploadService {
  Future<dynamic> uploadPhotos(String path) async {
    var apiKey = '1be1181ecb209b388e6ca24321b3b65d';
    MultipartFile file = await MultipartFile.fromFile(path);
    var formData = FormData.fromMap({'key': apiKey, 'image': file});

    var response =
        await Dio().post('https://api.imgbb.com/1/upload', data: formData);
    return response.data['data']['url'];
  }
}
