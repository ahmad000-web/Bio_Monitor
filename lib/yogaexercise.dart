import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YogaExercisePage extends StatefulWidget {
  @override
  _YogaExercisePageState createState() => _YogaExercisePageState();
}

class _YogaExercisePageState extends State<YogaExercisePage> {
  late YoutubePlayerController c1;
  late YoutubePlayerController c2;
  late YoutubePlayerController c3;

  @override
  void initState() {
    super.initState();

    c1 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/B4kNiCWTl7M?si=YTR6-vNylfleMlRq",
      )!,
    );

    c2 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/NQzDFgnyYAo?si=P9BU_4gsGfm6gz7C",
      )!,
    );

    c3 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/2ymyRJwFtV8?si=7XDnvCqIKER5Gu-2",
      )!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yoga Exercises"),
        backgroundColor: Colors.teal.shade900,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          yogaVideo("Breathing + Relaxation", c1),
          yogaInfo(
              "This exercise improves lung strength and mental relaxation."),
          yogaVideo("Basic Yoga Warmup", c2),
          yogaInfo("Helps improve flexibility and reduce morning stiffness."),
          yogaVideo("Full Body Stretch", c3),
          yogaInfo("Improves balance, flexibility, and muscle strength."),
        ],
      ),
    );
  }

  Widget yogaVideo(String title, YoutubePlayerController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        YoutubePlayer(controller: c),
        SizedBox(height: 20),
      ],
    );
  }

  Widget yogaInfo(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }
}
