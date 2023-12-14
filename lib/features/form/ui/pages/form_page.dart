import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';

import '../../../../core/util/my_style.dart';
import '../../bloc/get_form_cubit/get_form_cubit.dart';

class StartForm extends StatefulWidget {
  const StartForm({super.key});

  @override
  State<StartForm> createState() => _StartFormState();
}

class _StartFormState extends State<StartForm> {
  @override
  void initState() {
    context.read<GetFormCubit>().getQuestionsForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SizedBox(
        width: 1.0.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<GetFormCubit, GetFormInitial>(
                builder: (context, state) {
                  return SizedBox(
                    width: 1.0.sw,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
                      itemCount: state.result.length,
                      separatorBuilder: (_, i) => 10.0.verticalSpace,
                      itemBuilder: (_, i) {
                        final item = state.result[i];
                        return item.getWidget;
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
