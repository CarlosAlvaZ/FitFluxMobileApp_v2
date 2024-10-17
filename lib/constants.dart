import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

const unexpectedErrorMessage = "Unexpected error occurred.";

/// HTTPS endpoint to public DiceBear API. Append [seed] to generate svg
const dicebearAPI = "https://api.dicebear.com/9.x/notionists/webp?seed=";

extension ShowSnackBar on BuildContext {
  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

extension TextThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
