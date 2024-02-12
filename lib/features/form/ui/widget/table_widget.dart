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
              setState(
                  () => context.read<GetFormCubit>().setAnswer(widget.q, answers: list));
            }
          },
        ),
        DrawableText(text: (widget.q.answer?.answers ?? []).length.toString()),
        30.0.verticalSpace,
        Container(
          constraints: BoxConstraints(minHeight: 100.0.h, maxHeight: 1.0.sh),
          child: ListView.builder(
            itemCount: (widget.q.answer?.answers ?? []).length,
            itemBuilder: (_, i) {
              final e = widget.q.answer?.answers[i];
              if (e == null) return 0.0.verticalSpace;

              final itemWidget = _TableItemWidget(
                list: e,
                q: widget.q,
                onDelete: () {
                  setState(() => widget.q.answer?.answers.removeAt(i));
                },
              );

              return itemWidget;
            },
          ),
        ),
      ],
    );
  }
}

class _TableItemWidget extends StatefulWidget {
  const _TableItemWidget(
      {super.key, required this.list, required this.q, required this.onDelete});

  final List<Questions> list;
  final Questions q;

  final Function() onDelete;

  @override
  State<_TableItemWidget> createState() => _TableItemWidgetState();
}

class _TableItemWidgetState extends State<_TableItemWidget> {
  var key = GlobalKey();
  Size? redboxSize;

  bool isOffstage = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidgetHeight();
    });
    super.initState();
  }

  void _getWidgetHeight() {
    // Future.delayed(
    //   const Duration(milliseconds: 100),
    //   () {
    if (redboxSize == null) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox;
      redboxSize = renderBox.size;
      setState(() => isOffstage = false);
    }
    //   },
    // );
  }

  Size getRedBoxSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: isOffstage,
      child: Builder(
        builder: (context) {
          return Container(
            color: Colors.red,
            constraints: BoxConstraints(maxHeight: redboxSize?.height ?? double.infinity),
            height: redboxSize?.height,
            child: Row(
              key: key,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.list.map((e1) => e1.getTableAnswerWidget).toList()
                      ..add(const Divider()),
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onDelete.call(),
                  icon: const ImageMultiType(
                    url: Icons.remove_circle,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
