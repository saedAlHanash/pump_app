import 'dart:convert';

import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:pump_app/core/extensions/extensions.dart';
import 'package:pump_app/core/widgets/app_bar/app_bar_widget.dart';
import 'package:pump_app/core/widgets/my_card_widget.dart';

import '../../../../core/util/my_style.dart';
import '../../../../router/app_router.dart';
import '../../../db/models/app_specification.dart';
import '../../bloc/get_history_cubit/get_history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: BlocBuilder<GetHistoryCubit, GetHistoryInitial>(
        builder: (context, state) {
          if (state.statuses.loading) {
            return MyStyle.loadingWidget();
          }
          return ListView.separated(
            separatorBuilder: (_, i) => 10.0.verticalSpace,
            itemCount: state.result.length,
            itemBuilder: (_, i) {
              final item = state.result[i];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteName.answers,
                    arguments: item.list.expand((list) => list).toList(),
                  );
                },
                child: MyCardWidget(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            DrawableText(text: item.date.formatDate),
                            DrawableText(text: item.name ?? ''),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<GetHistoryCubit>().deleteItem(i);
                        },
                        icon: const ImageMultiType(
                          url: Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
