import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import 'CustomText.dart';

class CustomTextField extends StatefulWidget {
  final bool isPassword;
  final String headerText;
  final Widget? customheader;
  final String hint;
  Color textColor;
  Color borderFocusColor;
  TextEditingController? textEditingController;
  VoidCallback? onEditComplete;
  VoidCallback? onTap;
  FocusNode? focusNode;
  TextInputType? textInputType;
  int maxlines;
  bool isError;
  bool showPassword;

  CustomTextField(
      {super.key,
      this.isPassword = false,
      required this.headerText,
      required this.hint,
      this.onEditComplete,
      this.focusNode,
      this.customheader,
      this.textEditingController,
      this.isError = false,
      this.textColor = TextFieldColor,
      this.borderFocusColor = TextFieldColorFocus,
      this.textInputType,
      this.showPassword = false,
      this.maxlines = 1,
      this.onTap});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.customheader != null
            ? widget.customheader!
            : CustomText(
                text: widget.headerText,
                size: 16.sp,
                color: TextFieldColor,
              ),
        TextFormField(
          style:
              TextStyle(color: widget.isError ? Colors.red : widget.textColor),
          cursorColor: Colors.white,
          obscureText: widget.isPassword ? !widget.showPassword : false,
          obscuringCharacter: "*",
          minLines: 1,
          maxLines: widget.maxlines,
          // keyboardAppearance: ,
          autocorrect: !widget.isPassword,
          keyboardType: widget.textInputType ??
              (widget.isPassword
                  ? TextInputType.visiblePassword
                  : TextInputType.emailAddress),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: widget.isError ? Colors.red : widget.textColor),
            ),
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.showPassword = !widget.showPassword;
                      });
                    },
                    child: widget.showPassword
                        ? SvgPicture.asset("assets/svg/show.svg")
                        : SvgPicture.asset("assets/svg/hide.svg"))
                : widget.isError
                    ? SvgPicture.asset(
                        "assets/svg/errorsign.svg",
                        fit: BoxFit.scaleDown,
                      )
                    : null,
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: widget.isError ? Colors.red : widget.textColor,
            ),
            focusedBorder: UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: widget.borderFocusColor),
            ),
          ),
          onEditingComplete: widget.onEditComplete,
          focusNode: widget.focusNode,
          controller: widget.textEditingController,
          onTapOutside: ((event) {}),
          onTap: widget.onTap,
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.isError ? 4 : 0),
          child: CustomText(
            text: widget.isPassword
                ? ""
                : widget.isError
                    ? "This email is not valid please try again"
                    : "",
            align: Alignment.bottomLeft,
            color: ErrorMesseageText,
            size: 14,
          ),
        )
      ],
    );
  }
}
