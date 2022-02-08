import 'package:camera/camera.dart';
import 'package:chistaya_linia_test/cubit/camera/camera_cubit.dart';
import 'package:chistaya_linia_test/widgets/link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription? camera;

  const CameraScreen({Key? key, this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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

  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<CameraCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take picture'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file = await cameraCubit.takePicture(_controller);
          cameraCubit.postImage(file!.path);
        },
        child: const Icon(Icons.camera_alt),
      ),
      body: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          if (state is Initial) {
            return initializeCamera();
          }
          if (state is UploadingImage) {
            return const Center(child: Text('uploading'));
          }
          if (state is UploadingImageSuccess) {
            return LinkWidget(photo: state.photo);
          }
          if (state is UploadingImageFailed) {
            return const Text('UploadingFailed');
          }
          return const Text('error');
        },
      ),
    );
  }

  Widget initializeCamera() => FutureBuilder<void>(
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
      );
}
