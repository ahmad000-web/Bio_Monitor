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
  late YoutubePlayerController c4;
  late YoutubePlayerController c5;
  late YoutubePlayerController c6;
  late YoutubePlayerController c7;
  late YoutubePlayerController c8;
  late YoutubePlayerController c9;



  @override
  void initState() {
    super.initState();

    c1 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/brjAjq4zEIE?si=RuhilKX60CfyJynF",
      )!,
    );

    c2 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/glONapH5flo?si=kLu9JqU5aWtODX4W",
      )!,
    );

    c3 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/-TJcZRrOenA?si=cP4yGmwuajs38W0H",
      )!,
    );
    c4 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/T3fxXYmQSOI?si=ECBpJWoIk_tIUjK8",
      )!,
    );
    c5 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/9EPcRrcH_JQ?si=-aq97WuDxRWVfodu",
      )!,
    );
    c6 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "ttps://youtu.be/JmOBM160jZ0?si=s_pgZmi8IfgYWbRq",
      )!,
    );
    c7 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        "https://youtu.be/JmOBM160jZ0?si=s_pgZmi8IfgYWbRq",
      )!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yoga Exercises",
          style: TextStyle(color: Colors.white),
        ),
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
          yogaVideo("Brain Activaion", c4),
          yogaInfo("Mindful Exercises for Movement to yoga for children."),
          yogaVideo("7 brain Exercises", c5),
          yogaInfo("Brain Exercises that instantly Boost Power & focus."),
          yogaVideo("21 Days challenge", c6),
          yogaInfo("How to reprogram your Mind for suceess"),
          yogaVideo("Fast Morning Exercise for Full Body ", c7),
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
