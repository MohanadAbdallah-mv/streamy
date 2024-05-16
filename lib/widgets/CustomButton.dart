import 'package:flutter/material.dart';

import '../constants.dart';

class CustomElevatedButton extends StatelessWidget {
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

  const CustomElevatedButton({
    super.key,
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
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onpress,
        child: child,
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
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
  final VoidCallback onPress;

  const CustomOutlinedButton({
    super.key,
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
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: InkRipple.splashFactory,
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        fixedSize: MaterialStatePropertyAll(
          Size(
            width,
            height,
          ),
        ),
      ),
      onPressed: onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: gradientBorder,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
