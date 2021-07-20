import 'dart:math';

import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const ImagePlaceholder({required this.width, required this.height});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double newWidth = min(width, constraints.maxWidth);
        return Center(
          child: Container(
            width: width,
            height: newWidth * height / width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
