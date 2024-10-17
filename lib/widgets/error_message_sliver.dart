import 'package:flutter/material.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';

class ErrorMessageSliver extends StatelessWidget {
  const ErrorMessageSliver({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "404",
          style: context.textTheme.displayLarge!.copyWith(
              color: Colors.white,
              fontSize: 100,
              letterSpacing: 10,
              fontWeight: FontWeight.w900),
        ),
        Text(
          "Ha ocurrido un error",
          style: context.textTheme.headlineLarge,
        ),
        Text(
          "Por favor, intentalo más tarde",
          style: context.textTheme.bodySmall,
        ),
      ],
    ));
  }
}
