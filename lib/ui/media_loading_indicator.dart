import 'package:flutter/material.dart';

class MediaLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.38,
        child: new Center(
          child: CircularProgressIndicator(),
        ));
  }
}
