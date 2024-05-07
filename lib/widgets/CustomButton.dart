import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  final Gradient? gradient;
  final Gradient? gradientBorder;
  final Color color;
  final Color? borderColor;
  final Color? buttonBackgroundColor;
  final double borderRadius;
  final double height;
  final double width;
  final Widget child;
  final double thickness;
  final VoidCallback onpress;

  const CustomButton(
      {super.key,
      this.gradient = null,
      this.gradientBorder = null,
      this.color = buttonColor,
      this.borderColor,
      this.buttonBackgroundColor,
      this.height = 50,
      this.width = double.maxFinite,
      this.borderRadius = 50,
      this.thickness = 0,
      required this.child,
      required this.onpress});

//gradient=null,color,width,height,child,onpressed
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onpress,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradientBorder,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: gradient,
              //  color: color,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              border: borderColor == color
                  ? null
                  : Border.all(color: borderColor!)),
          child: Container(
            margin: EdgeInsets.all(thickness),
            width: width,
            height: height,
            constraints: BoxConstraints(minHeight: height, minWidth: width),
            decoration: BoxDecoration(
                color: buttonBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}
