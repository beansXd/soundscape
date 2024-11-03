import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:soundscape/Player_screen.dart';

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
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              print(list[index]);
                                if (mp3Files.containsKey(list[index]) == true ) {
                                  print("Map contains Key");
                                 var checj=   mp3Files[list[index]];
                                 print(checj);
                                }else{
                                  print("Key is not found");

                                }

                              return Player(songName: list[index], songPath: mp3Files[list[index]]  )    ;
                            },));

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
