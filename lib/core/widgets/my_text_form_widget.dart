import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../strings/app_color_manager.dart';
import '../util/my_style.dart';

class MyTextFormOutLineWidget extends StatefulWidget {
  const MyTextFormOutLineWidget({
    Key? key,
    this.label = '',
    this.helperText,
    this.hint = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.isRequired = false,
    this.textAlign = TextAlign.start,
    this.maxLength = 1000,
    this.onChanged,
    this.controller,
    this.keyBordType,
    this.innerPadding,
    this.enable,
    this.icon,
    this.color = Colors.black,
    this.initialValue,
    this.textDirection,
    this.validator,
    this.iconWidget,
    this.iconWidgetLift,
    this.onChangedFocus,
  }) : super(key: key);
  final bool? enable;
  final String label;
  final Widget? helperText;
  final String hint;
  final dynamic icon;
  final Widget? iconWidget;
  final Widget? iconWidgetLift;
  final Color color;
  final int maxLines;
  final int maxLength;
  final bool obscureText;
  final bool isRequired;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Function(bool)? onChangedFocus;

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyBordType;
  final EdgeInsets? innerPadding;
  final String? initialValue;
  final TextDirection? textDirection;

  @override
  State<MyTextFormOutLineWidget> createState() => _MyTextFormOutLineWidgetState();
}

class _MyTextFormOutLineWidgetState extends State<MyTextFormOutLineWidget> {
  FocusNode? focusNode;

  @override
  void initState() {
    if (widget.onChangedFocus != null) {
      focusNode = FocusNode()
        ..addListener(() {
          widget.onChangedFocus!.call(focusNode!.hasFocus);
        });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.innerPadding ?? const EdgeInsets.symmetric(horizontal: 20.0).w;

    bool obscureText = widget.obscureText;
    Widget? suffixIcon;
    VoidCallback? onChangeObscure;

    if (widget.iconWidget != null) {
      suffixIcon = widget.iconWidget!;
    } else if (widget.icon != null) {
      suffixIcon = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
        child: ImageMultiType(url: widget.icon!, height: 23.0.h, width: 40.0.w),
      );
    }

    if (obscureText) {
      suffixIcon = StatefulBuilder(builder: (context, state) {
        return IconButton(
            splashRadius: 0.01,
            onPressed: () {
              state(() => obscureText = !obscureText);
              if (onChangeObscure != null) onChangeObscure!();
            },
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off));
      });
    }

    final border = OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.color,
          width: 1.0.spMin,
        ),
        borderRadius: BorderRadius.circular(12.0.r));

    final focusedBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColorManager.mainColor,
          width: 1.0.spMin,
        ),
        borderRadius: BorderRadius.circular(12.0.r));

    final errorBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColorManager.red,
          width: 1.0.spMin,
        ),
        borderRadius: BorderRadius.circular(12.0.r));

    final inputDecoration = InputDecoration(
      contentPadding: padding,
      errorBorder: errorBorder,
      border: border,
      focusedBorder: focusedBorder,
      enabledBorder: border,
      fillColor: AppColorManager.lightGray,
      label: DrawableText(
        text: widget.label.toUpperCase(),
        color: AppColorManager.gray,
        size: widget.label.length > 40
            ? 10.0.sp
            : widget.label.length > 30
                ? 12.0.sp
                : 14.0.sp,
        fontFamily: FontManager.cairo.name,
      ),
      counter: widget.helperText??const SizedBox(),
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: widget.color),
      suffixIcon: widget.obscureText ? suffixIcon : widget.iconWidgetLift,
      prefixIcon: widget.obscureText ? null : suffixIcon,
    );

    final textStyle = TextStyle(
      fontFamily: FontManager.cairoSemiBold.name,
      fontSize: 16.0.spMin,
      color: AppColorManager.black,
    );

    return StatefulBuilder(builder: (context, state) {
      onChangeObscure = () => state(() {});
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0).h,
        child: TextFormField(
          validator: widget.validator,
          decoration: inputDecoration,
          maxLines: widget.maxLines,
          readOnly: !(widget.enable ?? true),
          initialValue: widget.initialValue,
          obscureText: obscureText,
          textAlign: widget.textAlign,
          onChanged: widget.onChanged,
          style: textStyle,
          focusNode: focusNode,
          textDirection: widget.textDirection,
          maxLength: widget.maxLength,
          controller: widget.controller,
          keyboardType: widget.keyBordType,
        ),
      );
    });
  }
}

class MyTextFormNoLabelWidget extends StatelessWidget {
  const MyTextFormNoLabelWidget({
    Key? key,
    this.label = '',
    this.hint = '',
    this.maxLines = 1,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.maxLength = 1000,
    this.onChanged,
    this.controller,
    this.keyBordType,
    this.innerPadding,
    this.enable,
    this.icon,
    this.color = Colors.black,
    this.initialValue,
    this.textDirection,
  }) : super(key: key);
  final bool? enable;
  final String label;
  final String hint;
  final String? icon;
  final Color color;
  final int maxLines;
  final int maxLength;
  final bool obscureText;
  final TextAlign textAlign;
  final Function(String val)? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyBordType;
  final EdgeInsets? innerPadding;
  final String? initialValue;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawableText(
          text: label,
          matchParent: true,
          color: AppColorManager.black,
          padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
          size: 18.0.sp,
        ),
        3.0.verticalSpace,
        MyTextFormOutLineWidget(
          maxLines: maxLines,
          initialValue: initialValue,
          obscureText: obscureText,
          textAlign: textAlign,
          onChanged: onChanged,
          textDirection: textDirection,
          maxLength: maxLength,
          controller: controller,
          color: color,
          enable: enable,
          hint: hint,
          keyBordType: keyBordType,
          icon: icon,
          innerPadding: innerPadding,
          key: key,
        ),
        5.0.verticalSpace,
      ],
    );
  }
}

class RectCustomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) => Rect.fromLTWH(3.w, 0, size.width - 6.w, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => oldClipper != this;
}
