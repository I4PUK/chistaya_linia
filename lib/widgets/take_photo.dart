import 'package:camera/camera.dart';
import 'package:chistaya_linia_test/dio_upload_service.dart';
import 'package:chistaya_linia_test/widgets/link.dart';
import 'package:flutter/material.dart';

class TakePhoto extends StatefulWidget {
  final CameraDescription? camera;

  const TakePhoto({Key? key, this.camera}) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  final DioUploadService _dioUploadService = DioUploadService();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera as CameraDescription,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  Future<XFile?> takePicture() async {
    if (_controller.value.isTakingPicture) {
      return null;
    }

    try {
      XFile file = await _controller.takePicture();
      return file;
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take picture'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file = await takePicture();      
          // calling with dio
          var responseDataDio =
              await _dioUploadService.uploadPhotos(file!.path);
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return LinkWidget(text: responseDataDio.toString());
              },
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
