import 'package:chistaya_linia_test/models/photo_info.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';

class LinkWidget extends StatelessWidget {
  final PhotoInfo photo;

  const LinkWidget({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            LinkText(
              photo.url!,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
