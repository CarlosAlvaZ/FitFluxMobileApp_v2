import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/widgets/text_gesture_button.dart';
import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.redPrimary,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/walking_dog.png'),
              Text(
                "Sesión finalizada con éxito",
                textAlign: TextAlign.center,
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Has terminado una sesión de ejercicios con éxito",
                textAlign: TextAlign.center,
                style: context.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.w200, color: Colors.white70),
              ),
              const SizedBox(
                height: 32,
              ),
              TextGestureButton(
                  onTap: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil("/home", (route) => false),
                  text: "Regresar a principal")
            ],
          ),
        ),
      ),
    );
  }
}
