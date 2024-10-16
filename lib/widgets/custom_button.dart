import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.radius = 4.0,
    this.width = double.infinity,
    this.padding = 16.0,
  });
  final String text;
  final void Function()? onPressed;
  final Color color;
  final Color textColor;
  final double radius;
  final double width;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(padding),
              backgroundColor:
                  onPressed == null ? color.withOpacity(0.5) : color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
          child: Text(text,
              style:
                  context.textTheme.labelMedium!.copyWith(color: textColor))),
    );
  }
}
