import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/util/snack_bar_message.dart';
import 'package:pump_app/main.dart';

import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../../core/widgets/q_header_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../db/models/app_specification.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class NumberWidget extends StatefulWidget {
  const NumberWidget({super.key, required this.q});

  final Questions q;

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.q.answer?.answer ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QHeaderWidget(q: widget.q),
        5.0.verticalSpace,
        MyTextFormOutLineWidget(
          isRequired: widget.q.isRequired,
          keyBordType: TextInputType.number,
          controller: controller,
          helperText: widget.q.max != null
              ? Transform.translate(
                  offset: Offset(10.w, -8.h),
                  child: DrawableText(
                    text: '${S.of(context).from} ${widget.q.sMin} ${S.of(context).to} ${widget.q.sMax}',
                    color: Colors.green,
                    underLine: true,
                    size: 12.0.sp,
                    matchParent: true,
                  ),
                )
              : null,
          onChanged: (val) {
            loggerObject.w(val);
            num n = num.tryParse(val) ?? 0;
            if (n < widget.q.min || n > widget.q.max) {
              controller.value = controller.value.copyWith(
                text: widget.q.answer?.answer ?? '',
                selection: TextSelection.collapsed(offset: (widget.q.answer?.answer ?? '').length),
              );
              NoteMessage.showErrorSnackBar(
                  message: S.of(context).wrongInputData, context: context);
              return;
            }
            context.read<GetFormCubit>().setAnswer(widget.q, sAnswer: val);
          },
        ),
      ],
    );
  }
}
