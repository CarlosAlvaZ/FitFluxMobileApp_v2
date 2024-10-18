import 'package:flutter/material.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';

class EmptyMessageSliver extends StatelessWidget {
  const EmptyMessageSliver({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/home_bg.png')),
          Text(
            "Tu rutina está vacía",
            style: context.textTheme.headlineLarge,
          ),
          Text(
            "Empieza añadiendo actividades con + Añadir ejercicio",
            style: context.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
