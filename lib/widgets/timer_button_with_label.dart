import 'package:fit_flux_mobile_app_v2/widgets/play_button.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

class TimerButtonWithLabel extends StatelessWidget {
  const TimerButtonWithLabel({
    super.key,
    required this.color,
    required this.backgroundColor,
    required this.icon,
    required this.width,
    required this.label,
    required this.onPressed,
    required this.size,
  });

  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final double width;
  final double size;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          TimerActionButton(
              onPressed: onPressed,
              size: size,
              icon: icon,
              backgroundColor: backgroundColor,
              color: color),
          const SizedBox(
            height: 8,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style:
                context.textTheme.bodyMedium!.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
