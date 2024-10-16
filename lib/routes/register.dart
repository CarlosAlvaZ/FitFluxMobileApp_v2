import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/utils/field_validator.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_button.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_text_input.dart';
import 'package:fit_flux_mobile_app_v2/widgets/text_gesture_button.dart';
import 'package:flutter/material.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;

    try {
      setState(() => _isLoading = true);
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } on AuthException catch (error) {
      context.showSnackBar(message: error.message);
    } catch (error) {
      context.showSnackBar(message: unexpectedErrorMessage);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.extraPrimary,
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              "Registrate",
              style: context.textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 52.0,
            ),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nombre de usuario",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CustomTextInput(
                      hintText: "Ingresa tu nombre de usuario",
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo requerido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      "Correo electrónico",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CustomTextInput(
                      hintText: "Ingresa tu correo electrónico",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) =>
                          FieldValidator.validateEmailField(value),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      "Contraseña",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    CustomTextInput(
                      hintText: "Ingresa tu contraseña",
                      controller: _passwordController,
                      isObscured: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo requerido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 64.0,
                    ),
                    CustomButton(
                        text: "Registrarse",
                        onPressed: _isLoading ? null : _signUp)
                  ],
                )),
            const SizedBox(
              height: 48.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Ya tienes una cuenta?"),
                const SizedBox(
                  width: 8.0,
                ),
                TextGestureButton(
                    text: "Inicia sesión",
                    onTap: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false))
              ],
            ),
          ],
        ));
  }
}
