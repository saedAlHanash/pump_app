import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../strings/app_color_manager.dart';

class SelectSingeDateWidget extends StatelessWidget {
  const SelectSingeDateWidget({
    super.key,
    this.onSelect,
    this.initial,
    this.maxDate,
    this.minDate,
    required this.controller,
  });

  final DateTime? initial;
  final DateTime? maxDate;
  final DateTime? minDate;
  final TextEditingController controller;
  final Function(DateTime? selected)? onSelect;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      surfaceTintColor: Colors.white,
      constraints: BoxConstraints(maxHeight: 1.0.sh, maxWidth: 1.0.sw),
      splashRadius: 0.001,
      color: Colors.white,
      padding: const EdgeInsets.all(5.0).r,
      elevation: 2.0,
      iconSize: 0.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      itemBuilder: (context) => [
        // PopupMenuItem 1
        PopupMenuItem(
          value: 1,
          enabled: false,
          // row with 2 children
          child: SizedBox(
            height: .3.sh,
            width: 0.8.sw,
            child: Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: SfDateRangePicker(
                  initialSelectedDate: initial,
                  maxDate: maxDate,
                  minDate: minDate,
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs range) {
                    if (range.value is DateTime) {
                      onSelect?.call(range.value);
                      Navigator.pop(context);
                    } else if (range.value is PickerDateRange) {}
                  },
                  selectionMode: DateRangePickerSelectionMode.single,
                ),
              ),
            ),
          ),
        ),
      ],
      child: IgnorePointer(
        child: SizedBox(
          width: 1.0.sw,
          child: DrawableText(
            text: controller.text,
            matchParent: true,
            drawablePadding: 10.0.w,
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0).r,
            drawableStart: const ImageMultiType(url: Icons.date_range),
          ),
        ),
      ),
    );
  }
}


