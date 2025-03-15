import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image as the base layer
        Positioned.fill(child: Container(color: Colors.amber)),
        // Caption or overlay at the bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
            child: Text("Image 123", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
