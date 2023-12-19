import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/icon_stepper_widget.dart';
import 'package:pump_app/core/widgets/my_button.dart';

import '../../../../core/strings/app_string_manager.dart';
import '../../../../core/util/my_style.dart';
import '../../../../core/util/snack_bar_message.dart';
import '../../../../router/app_router.dart';
import '../../../history/data/history_model.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class StartForm extends StatefulWidget {
  const StartForm({super.key, this.pageNumber = 0});

  final int pageNumber;

  @override
  State<StartForm> createState() => _StartFormState();
}

class _StartFormState extends State<StartForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: BlocBuilder<GetFormCubit, GetFormInitial>(
          builder: (context, state) {
            if (state.statuses.loading) {
              return 0.0.verticalSpace;
            }
            return IconStepperDemo(
              items: state.result
                  .mapIndexed(
                    (i, e) => StepperItem(
                      active: i == widget.pageNumber,
                      complete: i < widget.pageNumber,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      body: SizedBox(
        width: 1.0.sw,
        child: BlocBuilder<GetFormCubit, GetFormInitial>(
          builder: (context, state) {
            if (state.statuses.loading) {
              return MyStyle.loadingWidget();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.pageNumber < state.result.length )
                    Column(
                      children: state.result[widget.pageNumber]
                          .mapIndexed(
                            (i, item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0).h,
                              child: item.getWidget,
                            ),
                          )
                          .toList(),
                    ),
                  if (widget.pageNumber < state.result.length - 1)
                    MyButton(
                      text: 'التالي',
                      onTap: () {
                        final error =
                            context.read<GetFormCubit>().isComplete(widget.pageNumber);
                        if (error.isNotEmpty) {
                          NoteMessage.showAwesomeError(context: context, message: error);
                          return;
                        }
                        Navigator.pushNamed(context, RouteName.startForm,
                            arguments: widget.pageNumber + 1);
                      },
                    )
                  else
                    MyButton(
                      text: 'حفظ',
                      onTap: () async {
                        final box =
                            await Hive.openBox<String>(AppStringManager.answerBox);

                        if (!mounted) return;

                        final model = HistoryModel(
                          list: context.read<GetFormCubit>().state.result,
                          date: DateTime.now(),
                        );
                        box.add(
                          jsonEncode(model.toJson()),
                        );
                        box.close();
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteName.home, (route) => false);
                      },
                    ),
                  20.0.verticalSpace,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
