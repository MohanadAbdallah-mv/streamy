import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  final Gradient? gradient;
  final Color color;
  final Color? borderColor;
  final double borderRadius;
  final double height;
  final double width;
  final Widget child;
  final VoidCallback onpress;

  const CustomButton(
      {super.key,
      this.gradient = null,
      this.color = buttonColor,
      this.borderColor,
      this.height = 50,this.width=double.maxFinite,this.borderRadius=50,
      required this.child,
      required this.onpress});

//gradient=null,color,width,height,child,onpressed
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(0),
      onPressed: onpress,
      child: Ink(
        decoration: BoxDecoration(
            gradient: gradient,
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            border:
                borderColor==color? null :Border.all(color: borderColor!)),
        child: Container(
          width: width,
          height: height,
          constraints: BoxConstraints(minHeight: height,minWidth: width),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
