import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/main.dart';

import '../strings/app_color_manager.dart';

class SpinnerWidget<T> extends StatefulWidget {
  const SpinnerWidget({
    Key? key,
    required this.items,
    this.hint,
    this.hintText,
    this.onChanged,
    this.customButton,
    this.width,
    this.dropdownWidth,
    this.sendFirstItem,
    this.isRequired = false,
    this.expanded,
    this.isOverButton,
    this.decoration,
  }) : super(key: key);

  final List<SpinnerItem> items;
  final Widget? hint;
  final String? hintText;
  final Widget? customButton;
  final Function(SpinnerItem spinnerItem)? onChanged;
  final double? width;
  final double? dropdownWidth;
  final bool? sendFirstItem;
  final bool isRequired;
  final bool? expanded;
  final bool? isOverButton;
  final BoxDecoration? decoration;

  @override
  State<SpinnerWidget<T>> createState() => SpinnerWidgetState<T>();
}

class SpinnerWidgetState<T> extends State<SpinnerWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawableText(
          text: widget.hintText ?? '',
          color: AppColorManager.gray,
          size: 14.0.sp,
          matchParent: true,
          fontFamily: FontManager.cairo,
          drawableStart: widget.isRequired
              ? DrawableText(
                  text: ' * ',
                  color: Colors.red,
                  drawablePadding: 5.0.w,
                )
              : null,
        ),
        DropdownButton2(
          items: widget.items.map(
            (item) {
              final padding = (item.icon == null)
                  ? const EdgeInsets.symmetric(horizontal: 10.0).w
                  : EdgeInsets.only(left: 10.0.w);

              return DropdownMenuItem(
                value: item,
                child: DrawableText(
                  selectable: false,
                  text: item.name ?? '',
                  padding: padding,
                  color: (item.id != '-1')
                      ? (item.enable)
                          ? Colors.black
                          : AppColorManager.gray.withOpacity(0.7)
                      : AppColorManager.gray.withOpacity(0.7),
                  drawableStart: item.icon,
                  drawablePadding: item.icon != null ? 15.0.w : null,
                ),
              );
            },
          ).toList(),
          value: widget.items.firstWhereOrNull((e) => e.isSelected),
          hint: widget.hint,
          onChanged: (value) {
            if (widget.onChanged != null) widget.onChanged!(value!);
            setState(() {
              if (!(value!).enable) return;
              for (var e in widget.items) {
                e.isSelected = false;
                if (e.id == value.id) e.isSelected = true;
              }
            });
          },
          buttonStyleData: ButtonStyleData(
            width: widget.width,
            height: 60.0.h,
            decoration: widget.decoration ??
                BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0.r),
                  color: AppColorManager.f1.withOpacity(0.5),
                ),
            padding: const EdgeInsets.only(right: 10.0).w,
            elevation: 0,
          ),
          dropdownStyleData: DropdownStyleData(
            width: widget.dropdownWidth,
            maxHeight: 0.6.sh,
            padding: const EdgeInsets.only(bottom: 10.0).h,
            useSafeArea: true,
            elevation: 2,
            isOverButton: widget.isOverButton ?? false,
          ),
          iconStyleData: IconStyleData(
            icon: Row(
              children: [
                const Icon(
                  Icons.expand_more,
                  color: AppColorManager.mainColor,
                ),
                18.0.horizontalSpace,
              ],
            ),
            iconSize: 25.0.spMin,
          ),
          isExpanded: widget.expanded ?? false,
          customButton: widget.customButton,
          underline: 0.0.verticalSpace,
        ),
        20.0.verticalSpace,
      ],
    );
  }
}

class SpinnerOutlineTitle extends StatelessWidget {
  const SpinnerOutlineTitle({
    super.key,
    required this.items,
    this.hint,
    this.onChanged,
    this.customButton,
    this.width,
    this.dropdownWidth,
    this.sendFirstItem,
    this.expanded,
    this.decoration,
    this.label = '',
  });

  final List<SpinnerItem> items;
  final Widget? hint;
  final Widget? customButton;
  final Function(SpinnerItem spinnerItem)? onChanged;
  final double? width;
  final double? dropdownWidth;
  final bool? sendFirstItem;
  final bool? expanded;
  final BoxDecoration? decoration;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawableText(
          selectable: false,
          text: label,
          color: AppColorManager.black,
          padding: const EdgeInsets.symmetric(horizontal: 10.0).w,
          size: 18.0.sp,
        ),
        3.0.verticalSpace,
        SpinnerWidget(
          items: items,
          hint: hint,
          onChanged: onChanged,
          customButton: customButton,
          width: width,
          dropdownWidth: dropdownWidth,
          sendFirstItem: sendFirstItem,
          expanded: expanded,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0.r),
            border: Border.all(color: AppColorManager.gray, width: 1.0.r),
          ),
        )
      ],
    );
  }
}

class SpinnerItem {
  SpinnerItem({
    this.name,
    this.id,
    this.fId,
    this.isSelected = false,
    this.item,
    this.icon,
    this.enable = true,
  });

  String? name;
  String? id;
  String? fId;
  bool isSelected;
  bool enable;
  dynamic item;
  Widget? icon;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'fId': id,
      'isSelected': isSelected,
      'enable': enable,
      'item': item,
    };
  }

  factory SpinnerItem.fromJson(Map<String, dynamic> map) {
    return SpinnerItem(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      fId: map['fId'] ?? 0,
      isSelected: map['isSelected'] as bool,
      enable: map['enable'] as bool,
      item: map['item'] as dynamic,
    );
  }
}
