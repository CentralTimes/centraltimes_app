import 'dart:math';

import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final num width;
  final num height;

  const ImagePlaceholder({required this.width, required this.height});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double newWidth = min(width.toDouble(), constraints.maxWidth);
        return Center(
          child: Container(
            width: width.toDouble(),
            height: newWidth * height.toDouble() / width.toDouble(),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
