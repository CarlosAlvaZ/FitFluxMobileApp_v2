import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

class ExcerciseListItem extends StatelessWidget {
  const ExcerciseListItem({
    super.key,
    required this.exercise,
  });

  final Excercise exercise;

  String _formatDurationToPrint(int duration) {
    final minutes = (duration / 60).floor();
    return "$minutes:${duration - (minutes * 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        tileColor: AppColors.extraQuaternary,
        title: Text(exercise.name),
        subtitle: Text(exercise.description),
        trailing: exercise.isFlexible
            ? const Icon(Icons.alarm)
            : Text(
                _formatDurationToPrint(exercise.duration),
                style: context.textTheme.labelMedium,
              ),
      ),
    );
  }
}
