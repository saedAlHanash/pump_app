import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/widgets/my_text_form_widget.dart';
import '../../../../core/widgets/q_header_widget.dart';
import '../../../../core/widgets/spinner_widget.dart';
import '../../../db/models/app_specification.dart';
import '../../../db/models/item_model.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class ListStringWidget extends StatefulWidget {
  const ListStringWidget({super.key, required this.q});

  final Questions q;

  @override
  State<ListStringWidget> createState() => _ListStringWidgetState();
}

class _ListStringWidgetState extends State<ListStringWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.q.answer?.id);
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
          maxLines: 5,
          controller: controller,
          onChanged: (val) {
            context.read<GetFormCubit>().setAnswer(widget.q, sAnswer: val);
          },
        ),
      ],
    );
  }
}
