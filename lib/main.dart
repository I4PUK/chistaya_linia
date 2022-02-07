import 'package:chistaya_linia_test/card_picture.dart';
import 'package:chistaya_linia_test/take_photo.dart';
import 'package:chistaya_linia_test/dio_upload_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Upload',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Upload'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final HttpUploadService _httpUploadService = HttpUploadService();
  final DioUploadService _dioUploadService = DioUploadService();
  late CameraDescription _cameraDescription;
  final List<String> _images = [];
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

  Future<void> presentAlert(BuildContext context,
      {String title = '', String message = '', Function()? ok}) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message)
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'OK',
                  // style: greenText,
                ),
                onPressed: ok ?? Navigator.of(context).pop,
              ),
            ],
          );
        });
  }

  void presentLoader(BuildContext context,
      {String text = 'Aguarde...',
      bool barrierDismissible = false,
      bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Row(
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          children: [
            const Text('Send least two pictures', style: TextStyle(fontSize: 17.0)),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 400,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                        CardPicture(
                          onTap: () async {
                            final String? imagePath =
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => TakePhoto(
                                              camera: _cameraDescription,
                                            )));

                            print('imagepath: $imagePath');
                            if (imagePath != null) {
                              setState(() {
                                _images.add(imagePath);
                              });
                            }
                          },
                        ),
                        // CardPicture(),
                        // CardPicture(),
                      ] +
                      _images
                          .map((String path) => CardPicture(
                                imagePath: path,
                              ))
                          .toList()),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              // color: Colors.indigo,
                              gradient: LinearGradient(colors: [
                                Colors.indigo,
                                Colors.indigo.shade800
                              ]),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(3.0))),
                          child: RawMaterialButton(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            onPressed: () async {
                              // show loader
                              presentLoader(context, text: 'Wait...');

                              // calling with dio
                              var responseDataDio =
                                  await _dioUploadService.uploadPhotos(_images);

                              // calling with http
                              var responseDataHttp = await _dioUploadService
                                  .uploadPhotos(_images);

                              // hide loader
                              Navigator.of(context).pop();

                              // showing alert dialogs
                              await presentAlert(context,
                                  title: 'Success Dio',
                                  message: responseDataDio.toString());
                              await presentAlert(context,
                                  title: 'Success HTTP',
                                  message: responseDataHttp);
                            },
                            child: const Center(
                                child: Text(
                              'SEND',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                    )
                  ],
                ),),
          ],
        ),
      ),
    ));
  }
}