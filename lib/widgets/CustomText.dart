import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Alignment align;
  final TextAlign textalign;
  final FontWeight fontWeight;
  final String fontfamily;
  final bool trim;
  final bool linethrough;
  final bool underline;
  final TextOverflow? overflow;
  final double? height;
  final double? width;
  final int trimTo;
  const CustomText(
      {super.key,
      this.text = '',
      this.color = Colors.white,
      this.size = 16,
      this.align = Alignment.topLeft,
      this.textalign = TextAlign.center,
      this.fontWeight = FontWeight.normal,
      this.fontfamily = "ReadxPro",
      this.trim = false,
      this.linethrough = false,
      this.overflow,
      this.height,
      this.width,
      this.trimTo = 38,
      this.underline = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      height: height,
      width: width,
      child: Text(
        trim ? "${text.substring(0, trimTo)}..." : text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: fontWeight,
          fontFamily: "ReadexPro",
          overflow: overflow,
          decoration: linethrough
              ? TextDecoration.lineThrough
              : underline
                  ? TextDecoration.underline
                  : null,
        ),
        textAlign: textalign,
      ),
    );
  }
}
