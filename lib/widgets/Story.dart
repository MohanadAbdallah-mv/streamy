import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCircle extends StatefulWidget {
  bool myStatus;
  StoryCircle({super.key, this.myStatus = false});

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
        padding: EdgeInsets.only(left: 20),
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 52, // Twice the radius for diameter
                width: 52,
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
              widget.myStatus
                  ? Positioned(
                      bottom: 0,
                      right: 8,
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: FloatingActionButton(
                          heroTag: '<uniqueTag1>',
                          child: Icon(
                            Icons.add,
                            size: 8,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    )
                  : const SizedBox(),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(height: 16, child: Text("data")),
            ),
          ],
        ),
      ),
    );
  }
}
//                  "https://cdn3.vectorstock.com/i/1000x1000/91/32/face-young-man-in-frame-circular-avatar-character-vector-28829132.jpg",
