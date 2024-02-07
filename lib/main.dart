import 'package:flutter/material.dart';
import 'package:test_carousel/example_screen.dart';

int numItems = 10;
var onSelectCard = ValueNotifier<int>(0);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(platform: TargetPlatform.iOS, brightness: Brightness.dark),
      home: const ExampleScreen(),
    );
  }
}
