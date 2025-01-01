import 'package:entryflow/base_controller.dart';
import 'package:entryflow/theme/colors.dart';
import 'package:flutter/material.dart';

class ListManageButtons extends StatelessWidget {
  const ListManageButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            BaseController.to.refreshList(context);
          },
          icon: Icon(
            Icons.refresh_rounded,
            size: 26,
            color: AppColors.refreshListColor(Theme.of(context).brightness),
          ),
        ),
        IconButton(
          onPressed: BaseController.to.isSearchMode.value
              ? null
              : () {
                  BaseController.to.addAnItem(context);
                },
          icon: Icon(
            Icons.add,
            size: 30,
            color:
                // pastel blue,
                AppColors.addItemColor(Theme.of(context).brightness),
          ),
        ),
        IconButton(
          onPressed: () {
            BaseController.to.deleteAnItem(context);
          },
          icon: Icon(
            Icons.delete,
            size: 24,
            color:
                // pastel pink
                AppColors.deleteItemColor(Theme.of(context).brightness),
          ),
        ),
      ],
    );
  }
}