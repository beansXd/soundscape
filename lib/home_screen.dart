import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dircode.dart';
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
      body: Column(
        children: [
          Center(
            child: TextButton(onPressed: () {
              GetDowloads_Folder();
              listMp3FilesInDownloads();
            }, child: Text("Hi")),
          ),
        ],
      ),
    );
  }
}
