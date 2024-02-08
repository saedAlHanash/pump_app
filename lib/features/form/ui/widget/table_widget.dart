import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/features/form/ui/pages/form_table_page.dart';
import 'package:pump_app/main.dart';

import '../../../../core/widgets/my_button.dart';
import '../../../../generated/l10n.dart';
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

        MyButton(
          child: DrawableText(
            text: S.of(context).addDetails,
            color: Colors.white,
          ),
          onTap: () async {
            final list = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return FormTablePage(tableId: widget.q.tableNumber);
                },
              ),
            );

            if (list != null) {
              Future.delayed(
                const Duration(milliseconds: 600),
                    () {
                  setState(() =>
                      context.read<GetFormCubit>().setAnswer(widget.q, answers: list));
                },
              );
            }
          },
        ),
        30.0.verticalSpace,
        Container(
          constraints: BoxConstraints(minHeight: 100.0.h, maxHeight: 1.0.sh),
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...(widget.q.answer?.answers ?? []).mapIndexed((i, e) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: e.map((e1) => e1.getTableAnswerWidget).toList()
                              ..add(const Divider()),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => widget.q.answer?.answers.removeAt(i)),
                          icon: const ImageMultiType(
                            url: Icons.remove_circle,
                            color: Colors.red,
                          ),
                        )
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}
