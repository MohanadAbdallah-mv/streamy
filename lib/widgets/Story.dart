import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCircle extends StatefulWidget {
  const StoryCircle({super.key});

  @override
  State<StoryCircle> createState() => _StoryCircleState();
}

class _StoryCircleState extends State<StoryCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //push story page
      },
      child:  Column(
        children: [
          Expanded(flex: 5,
            child: CircleAvatar(
              maxRadius: 40,
              backgroundImage: NetworkImage(
                "https://cdn3.vectorstock.com/i/1000x1000/91/32/face-young-man-in-frame-circular-avatar-character-vector-28829132.jpg",
              ),
            ),
          ),
          Expanded(child: Text("data"))
        ],
      ),
    );
  }
}
