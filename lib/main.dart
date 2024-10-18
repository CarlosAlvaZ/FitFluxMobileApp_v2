import 'dart:io';

import 'package:fit_flux_mobile_app_v2/routes/account.dart';
import 'package:fit_flux_mobile_app_v2/routes/home.dart';
import 'package:fit_flux_mobile_app_v2/routes/login.dart';
import 'package:fit_flux_mobile_app_v2/routes/register.dart';
import 'package:fit_flux_mobile_app_v2/routes/splashpage.dart';
import 'package:fit_flux_mobile_app_v2/routes/success.dart';
import 'package:fit_flux_mobile_app_v2/routes/timer_view.dart';
import 'package:fit_flux_mobile_app_v2/themedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  if (await File('.env').exists()) {
    await dotenv.load(fileName: '.env');
  }
  final SUPABASE_URL =
      dotenv.env['SUPABASE_URL'] ?? String.fromEnvironment('SUPABASE_URL');
  final SUPABASE_ANON_KEY =
      dotenv.env['SUPABASE_ANON_KEY'] ?? String.fromEnvironment('SUPABASE_ANON_KEY');
  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFlux',
      theme: getThemeDataDark(context),
      routes: {
        '/home': (context) => const Home(),
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/account': (context) => const Account(),
        '/timer': (context) => const TimerView(),
        '/success': (context) => const Success(),
      },
      debugShowCheckedModeBanner: false,
      home: const Splashpage(),
    );
  }
}
