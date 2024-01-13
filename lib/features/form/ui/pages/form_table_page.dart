import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/strings/enum_manager.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';
import 'package:pump_app/features/db/models/app_specification.dart';
import 'package:pump_app/main.dart';

import '../../../../core/util/my_style.dart';
import '../../../../core/util/snack_bar_message.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class FormTablePage extends StatefulWidget {
  const FormTablePage({super.key, required this.tableId});

  final String tableId;

  @override
  State<FormTablePage> createState() => _FormTablePageState();
}

class _FormTablePageState extends State<FormTablePage> {
  final list = <Questions>[];

  @override
  void initState() {
    context.read<GetFormCubit>().state.result.forEach((e1) {
      for (var e in e1) {
        if (e.tableNumber == widget.tableId && e.qstType != QType.table) {
          if (e.equalTo.isEmpty) {
            e.answer = null;
          }
          list.add(e);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: BlocBuilder<GetFormCubit, GetFormInitial>(
        builder: (context, state) {
          return ListView.separated(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0).r,
            itemCount: list.length,
            separatorBuilder: (_, i) => 10.0.verticalSpace,
            itemBuilder: (_, i) {
              if (i == list.length - 1) {
                return Column(
                  children: [
                    list[i].getTableWidget,
                    10.0.verticalSpace,
                    MyButton(
                      text: S.of(context).add,
                      onTap: () {
                        final currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        final error = context.read<GetFormCubit>().iTable(list);

                        if (error.isNotEmpty) {
                          NoteMessage.showAwesomeError(context: context, message: error);
                          return;
                        }
                        // context.read<GetFormCubit>().saveEqualToTable(list);

                        Future.delayed(
                          const Duration(milliseconds: 500),
                          () {
                            Navigator.pop(context, list);
                          },
                        );
                      },
                    ),
                  ],
                );
              }
              return list[i].getTableWidget;
            },
          );
        },
      ),
    );
  }

  void flush(BuildContext context) {
    context.read<GetFormCubit>().state.result.forEach((e1) {
      for (var e in e1) {
        if (e.tableNumber == widget.tableId && e.qstType != QType.table) {
          e.answer = null;
        }
      }
    });
  }
}
