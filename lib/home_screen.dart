import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            'SoundScape',speed: Durations.extralong4,
          ),
        ],
      )),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
