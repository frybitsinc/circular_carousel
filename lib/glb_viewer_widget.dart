import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GlbViewerWidget extends StatelessWidget {
  const GlbViewerWidget({
    super.key,
    this.width = 200,
    this.height = 200,
    required this.path,
  });
  final double width;
  final double height;
  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: ModelViewer(
            src: path,
            autoRotate: true,
            disableZoom: true,
          ),
        )
    );
  }
}
