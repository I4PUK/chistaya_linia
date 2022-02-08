import 'package:chistaya_linia_test/models/photo_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkable/linkable.dart';

class LinkWidget extends StatelessWidget {
  final PhotoInfo photo;

  const LinkWidget({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('PHOTO URL: ' + photo.url!);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (photo.filename ?? 'No name') +
                  ", " +
                  photo.size.toString() +
                  "KB",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Linkify(
              onOpen: (userLink) async {
                if (await canLaunch(userLink.url)) {
                  await launch(userLink.url);
                } else {
                  throw 'Could not launch $userLink';
                }
              },
              text: photo.url ?? 'No name',
              linkStyle: TextStyle(color: Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Linkable(
              text: photo.url ?? 'No name',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
