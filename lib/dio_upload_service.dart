import 'package:dio/dio.dart';

class DioUploadService {
  
  Future<dynamic> uploadPhotos(List<String> paths) async {
    var apiKey = '1be1181ecb209b388e6ca24321b3b65d';
    List<MultipartFile> files = [];
    for(var path in paths) files.add(await MultipartFile.fromFile(path));
    var formData = FormData.fromMap({
      'key': apiKey,
      'image': files
    });

    var response = await Dio().post('https://api.imgbb.com/1/upload', data: formData);
    print('\n\n');
    print('RESPONSE WITH DIO');
    print(response.data);
    print('\n\n');
    return response.data;
  }

}