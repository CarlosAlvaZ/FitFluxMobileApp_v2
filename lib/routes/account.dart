import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () async {
            await supabase.auth.signOut();
            if (context.mounted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            }
          },
          child: const Text("Cerrar Sesión")),
    );
  }
}
