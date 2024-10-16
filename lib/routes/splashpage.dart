import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);

    final sesh = supabase.auth.currentUser;

    if (!mounted) return;

    if (sesh == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
