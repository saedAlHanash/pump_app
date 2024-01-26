import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/q_header_widget.dart';
import 'package:pump_app/features/form/bloc/get_form_cubit/get_form_cubit.dart';

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
    controller = TextEditingController(text: widget.q.answer?.answer);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QHeaderWidget(q: widget.q),
        5.0.verticalSpace,
        Builder(builder: (context) {
          var max =
              (widget.q.max is! DateTime) ? DateTime.now() : widget.q.max as DateTime;
          var min =
              (widget.q.min is! DateTime) ? DateTime(1900) : widget.q.min as DateTime;

          if (max.isBefore(min) || max == min) min = DateTime(1900);

          return MyTextFormOutLineWidget(
            controller: controller,
            enable: false,
            isRequired: widget.q.isRequired,
            iconWidget: SelectSingeDateWidget(
              initial: DateTime.tryParse(widget.q.answer?.answer ?? ''),
              minDate: min,
              maxDate: max,
              onSelect: (selected) {
                setState(() {
                  controller.text = selected?.formatDate ?? '';
                  context.read<GetFormCubit>().setAnswer(
                        widget.q,
                        sAnswer: selected?.formatDate,
                      );
                });
              },
            ),
          );
        }),
      ],
    );
  }
}
