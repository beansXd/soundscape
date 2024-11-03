import 'package:audioplayers/audioplayers.dart'; // Import the audio player package.
import 'package:flutter/material.dart'; // Import Flutter material design package.
import 'package:flutter_svg/flutter_svg.dart'; // Import the SVG support package.
import 'package:lottie/lottie.dart'; // Import the Lottie animation package.
import 'dart:async'; // Import Dart's async library for handling asynchronous operations.



class Player extends StatefulWidget {
  final String songName;

  final dynamic songPath;



  const Player({super.key, required this.songName , required  this.songPath  });

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer; // Instance of AudioPlayer to play audio files.

  late AnimationController _animationController; // Controller for the Lottie animation.
  Duration _duration = Duration.zero; // Total duration of the audio file.
  Duration _position = Duration.zero; // Current position of the playback.
  bool _isFirstSvg = true; // Flag to toggle between play and pause icons.
  bool _isAnimating = false; // Flag to prevent multiple toggles.
  bool _isPlaying = false; // Flag to indicate if audio is playing.

  // Stream subscriptions to listen to changes in audio player.
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _stateSubscription;
  StreamSubscription? _completionSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialize the audio player.

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    ); // Initialize the animation controller.

    // Listen for duration changes of the audio.
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });

    // Listen for position changes of the audio.
    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });

    // Listen for state changes of the audio player.
    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      if (mounted) {
        setState(() {
          _isPlaying = s == PlayerState.playing; // Update playing status.
          if (_isPlaying) {
            _animationController.repeat(); // Start animation if playing.
          } else {
            _animationController.stop(); // Stop animation if not playing.
          }
        });
      }
    });

    // Listen for completion of the audio playback.
    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _position = Duration.zero; // Reset position.
          _isPlaying = false; // Set playing status to false.
          _animationController.stop(); // Stop animation.
          _isFirstSvg = true; // Reset to the play icon.
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel all subscriptions and dispose resources.
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _stateSubscription?.cancel();
    _completionSubscription?.cancel();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> play() async {

    try {

      await _audioPlayer.play(DeviceFileSource(widget.songPath));
      setState(() {
        _isPlaying = true; // Update playing status.
      });
      _animationController.repeat(); // Start animation.
    } catch (e) {
      print("Error playing audio: $e"); // Handle any errors.
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop(); // Stop the audio playback.
    setState(() {
      _isPlaying = false; // Update playing status.
      _position = Duration.zero; // Reset position.
    });
    _animationController.stop(); // Stop animation.
  }

  void _toggleSvg() async {
    if (_isAnimating) return; // Prevent multiple toggles.
    setState(() {
      _isAnimating = true; // Set animating status to true.
    });

    if (_isPlaying) {
      await stop(); // Stop audio if playing.
    } else {
      await play(); // Play audio if not playing.
    }

    setState(() {
      _isFirstSvg = !_isFirstSvg; // Toggle the play/pause icon.
    });

    await Future.delayed(const Duration(seconds: 1)); // Delay to prevent quick toggling.
    setState(() {
      _isAnimating = false; // Reset animating status.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor, // Set the background color of the app bar.
        title: Text(widget.songName, style: const TextStyle(color: Colors.white)), // Set the title of the app bar.
        centerTitle: true, // Center the title in the app bar.
      ),
      body: Column(
        children: [
          // Lottie animation to show while playing audio.
          Expanded(
            child: Lottie.asset(
              "assets/Animation - 1717534821609.json",
              controller: _animationController,
              onLoaded: (composition) {
                _animationController.duration = composition.duration; // Set animation duration.
              },
            ),
          ),
          // Slider to show and control the audio position.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Slider(
                  value: _position.inSeconds.toDouble(), // Current position of the audio.
                  max: _duration.inSeconds.toDouble(), // Maximum duration of the audio.
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position); // Seek to the selected position.
                    if (!_isPlaying) {
                      await play(); // Start playing if not already playing.
                    }
                  },
                ),
                // Display current and total duration of the audio.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position)), // Current position.
                    Text(_formatDuration(_duration)), // Total duration.
                  ],
                ),
              ],
            ),
          ),
          // Toggle button to switch between play and pause.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _toggleSvg, // Handle tap to toggle play/pause.
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1), // Animation duration for switching icons.
                child: _isFirstSvg
                    ? SvgPicture.asset(
                  key: const ValueKey('first'),
                  width: 100,
                  height: 100,
                  "assets/play-circle-sharp-svgrepo-com.svg", // Play icon.
                )
                    : SvgPicture.asset(
                  key: const ValueKey('second'),
                  width: 100,
                  height: 100,
                  "assets/pause-svgrepo-com.svg", // Pause icon.
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper method to format the duration for display.
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
