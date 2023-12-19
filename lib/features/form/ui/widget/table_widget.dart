import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/util/snack_bar_message.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/features/form/ui/pages/form_table_page.dart';

import '../../../../core/widgets/my_button.dart';
import '../../../db/models/item_model.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({super.key, required this.q});

  final Questions q;

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (List<Questions> e in widget.q.answer?.answers ?? [])
          Column(
            children: e
                .map(
                  (e) => e.getTableAnswerWidget,
                )
                .toList()
              ..add(const Divider()),
          ),
        MyButton(
          child: const DrawableText(
            text: 'إضافة تفاصيل',
            color: Colors.white,
          ),
          onTap: () async {
            final list = await NoteMessage.showBottomSheet1(
              context,
              FormTablePage(tableId: widget.q.tableNumber),
            );
            if (list != null) {
              setState(() {
                context.read<GetFormCubit>().setAnswer(widget.q, answers: list);

              });
            }
          },
        ),
      ],
    );
  }
}
