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
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Column(
          children: [
            Container(
              height: 64.h, // Twice the radius for diameter
              width: 64.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    "https://banner2.cleanpng.com/20180612/hv/kisspng-computer-icons-designer-avatar-5b207ebb279901.8233901115288562511622.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h, child: const Text("data"))
          ],
        ),
      ),
    );
  }
}
//                  "https://cdn3.vectorstock.com/i/1000x1000/91/32/face-young-man-in-frame-circular-avatar-character-vector-28829132.jpg",
