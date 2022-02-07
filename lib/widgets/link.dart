import 'package:flutter/material.dart';

class LinkWidget extends StatelessWidget {
  final String? text;

  const LinkWidget({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(text ?? "Ничего", textAlign: TextAlign.center,),),
    );
  }
}