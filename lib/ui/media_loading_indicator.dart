import 'package:flutter/material.dart';

class MediaLoadingIndicator extends StatelessWidget {
  const MediaLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
        aspectRatio: 1.38,
        child: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
