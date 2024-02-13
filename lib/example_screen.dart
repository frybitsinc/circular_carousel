import 'package:flutter/material.dart';
import 'rotation_scene_v1.dart';
import 'rotation_scene_v2.dart';
import 'rotation_scene_v3.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: const Text("Examples"),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // _horizontalDemo(context),
            // _verticalDemo(context),
            _modelViewerTest(context),
          ],
        ),
      ),
    );
  }

  Widget _horizontalDemo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 42),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text("HORIZONTAL", style: TextStyle(fontSize: 24),),
          ),
          Expanded(child: RotationSceneV1()),
          Expanded(child: RotationSceneV3()),
          Expanded(child: RotationSceneV2()),
        ],
      ),
    );
  }
  Widget _verticalDemo(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: 800,
          maxHeight: MediaQuery.of(context).size.height*1.6
      ),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 42),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text("VERTICAL", style: TextStyle(fontSize: 24),),
          ),
          Expanded(
            flex: 1,
            child: RotationSceneV1(isVertical: true, isClockwise: false,),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: RotationSceneV3(isVertical: true, isClockwise: false,),
            )
          ),
          // Expanded(child: RotationSceneV2(isVertical: true),),
        ],
      ),
    );
  }

  Widget _modelViewerTest(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: 800,
          maxHeight: MediaQuery.of(context).size.height*1.6
      ),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 42),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("VERTICAL", style: TextStyle(fontSize: 24),),
          ),
          RotationSceneV3(isVertical: true, isClockwise: false,),
          // Expanded(child: RotationSceneV2(isVertical: true),),
        ],
      ),
    );
  }
}
