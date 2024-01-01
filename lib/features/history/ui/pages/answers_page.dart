import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/main.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/l10n.dart';

class AnswersPage extends StatefulWidget {
  const AnswersPage({super.key, required this.list});

  final List<Questions> list;

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  @override
  void initState() {
    widget.list.removeWhere((e) => e.tableNumber.isNotEmpty && e.qstType != QType.table);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: S.of(context).history),
      body: SizedBox(
        width: 1.0.sw,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
          itemCount: widget.list.length,
          separatorBuilder: (_, i) => 10.0.verticalSpace,
          itemBuilder: (_, i) {

            return widget.list[i].getTableAnswerWidget;
          },
        ),
      ),
    );
  }
}
