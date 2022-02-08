import 'package:camera/camera.dart';
import 'package:chistaya_linia_test/cubit/camera/camera_cubit.dart';
import 'package:chistaya_linia_test/widgets/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartWidget extends StatefulWidget {
  const StartWidget({Key? key, String? imagePath}) : super(key: key);

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  String text = 'Нажмите на кнопку';
  late CameraDescription _cameraDescription;

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(text)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => CameraCubit(const Initial()),
                child: CameraScreen(
                  camera: _cameraDescription,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
