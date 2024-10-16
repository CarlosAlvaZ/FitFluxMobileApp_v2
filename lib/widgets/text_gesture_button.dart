import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

class TextGestureButton extends StatelessWidget {
  const TextGestureButton({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: context.textTheme.labelMedium!
            .copyWith(decoration: TextDecoration.underline),
      ),
    );
  }
}

