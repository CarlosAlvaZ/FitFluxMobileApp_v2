import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

class ExcerciseListItem extends StatelessWidget {
  const ExcerciseListItem({
    super.key,
    required this.exercise,
    required this.onDismissed,
    required this.onTap,
  });

  final Excercise exercise;

  final Function(DismissDirection) onDismissed;
  final void Function() onTap;

  String _formatDurationToPrint(int duration) {
    final minutes = (duration / 60).floor();
    return "$minutes:${duration - (minutes * 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          decoration: const BoxDecoration(
              color: AppColors.redSecondary,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: onDismissed,
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.extraQuaternary,
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: ListTile(
            onTap: onTap,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            title: Text(exercise.name),
            subtitle: Text(exercise.description),
            trailing: exercise.isFlexible
                ? const Icon(Icons.alarm)
                : Text(
                    _formatDurationToPrint(exercise.duration),
                    style: context.textTheme.labelMedium,
                  ),
          ),
        ),
      ),
    );
  }
}
