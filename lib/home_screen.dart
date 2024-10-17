import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'dircode.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            'SoundScape',
            speed: Durations.extralong4,
          ),
        ],
      )),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: listMp3FilesInDownloads(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No MP3 files found.'));
                  } else {
                    var mp3Files = snapshot.data!;
                    var list = mp3Files.keys.toList();
                    return ListView.builder(
                      itemCount: mp3Files.length,
                      itemBuilder: (context, index) {




                        return InkWell(
                          onTap: () {

                          },
                          child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              // Set margins for the container.
                              padding: const EdgeInsets.all(10),
                              // Set padding inside the container.
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // Set the background color.
                                borderRadius: BorderRadius.circular(12),
                                // Set border radius for rounded corners.
                                boxShadow: [
                                  // Add a shadow effect.
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    // Shadow color with some opacity.
                                    spreadRadius: 2,
                                    // Spread radius of the shadow.
                                    blurRadius: 5,
                                    // Blur radius of the shadow.
                                    offset: const Offset(
                                        0, 3), // Offset position of the shadow.
                                  ),
                                ],
                              ),
                              child: ListTile(
                                onTap: () {

                                },

                                title: Text(
                                 list[index],


                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),


                                ),
                              )),
                        );


                      },
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
