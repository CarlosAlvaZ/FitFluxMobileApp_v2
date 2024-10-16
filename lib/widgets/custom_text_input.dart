import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:flutter/material.dart';

/// Parent should wrap [CustomTextInput] in [Form] widget
class CustomTextInput extends StatefulWidget {
  const CustomTextInput({
    super.key,
    this.controller,
    this.helperText,
    this.validator,
    this.hintText,
    this.borderColor = AppColors.extraTertiary,
    this.borderColorActive = Colors.white,
    this.backgroundColor = AppColors.extraSecondary,
    this.contentPadding = 16.0,
    this.borderRadius = 4.0,
    this.isObscured = false,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.isDisabled = false,
  });

  /// Parent widget should dispose [contoller] if passed as parameter
  final TextEditingController? controller;
  final String? helperText;
  final String? hintText;
  final Color borderColor;
  final Color borderColorActive;
  final Color backgroundColor;
  final double contentPadding;
  final bool isDisabled;
  final double borderRadius;

  /// Defaults to [TextInputType.text]
  final TextInputType keyboardType;
  final bool isObscured;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late final TextEditingController _controller;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.isObscured;
  }

  @override
  void dispose() {
    super.dispose();
    // has to dispose controller created inside the widget
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      style: context.textTheme.bodyMedium!.copyWith(color: Colors.white),
      readOnly: widget.isDisabled,
      obscureText: _obscureText,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      controller: _controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: widget.backgroundColor,
          helperText: widget.helperText,
          hintText: widget.hintText,
          hintStyle: context.textTheme.bodyMedium!
              .copyWith(color: AppColors.extraQuinary),
          contentPadding: EdgeInsets.all(widget.contentPadding),
          suffixIcon: widget.isObscured
              ? IconButton(
                  onPressed: () {
                    setState(() => _obscureText = !_obscureText);
                  },
                  icon: Icon(_obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined))
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.borderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide:
                  BorderSide(color: widget.borderColorActive, width: 1.0))),
      validator: widget.validator,
    );
  }
}
