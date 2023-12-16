import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/q_header_widget.dart';
import 'package:pump_app/features/db/models/item_model.dart';

import '../../../../core/strings/app_color_manager.dart';
import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../../core/widgets/select_date.dart';
import '../../../db/models/app_specification.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({super.key, required this.q});

  final Questions q;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.q.answer?.name);
    widget.q.answer ??= ItemModel.fromJson({});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QHeaderWidget(q: widget.q),
        5.0.verticalSpace,
        MyTextFormOutLineWidget(
          // validator: (p0) => signupCubit.validateBirthday,
          controller: controller,
          enable: false,
          isRequired: widget.q.isRequired,
          iconWidget: SelectSingeDateWidget(
            initial: (widget.q.answer?.name ?? '').isEmpty
                ? DateTime.now()
                : DateTime.tryParse(widget.q.answer!.name),
            maxDate: DateTime.now(),
            minDate: DateTime(1900),
            onSelect: (selected) {
              widget.q.answer?.name = selected?.formatDate ?? '';
              controller.text = selected?.formatDate ?? '';
            },
          ),
        ),
      ],
    );
  }
}
