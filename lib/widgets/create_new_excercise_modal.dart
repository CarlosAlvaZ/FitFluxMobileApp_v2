import 'package:duration_picker/duration_picker.dart';
import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_button.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_text_input.dart';
import 'package:flutter/material.dart';

class CreateNewExcerciseModal extends StatefulWidget {
  const CreateNewExcerciseModal({
    super.key,
    this.name,
    this.description,
    this.duration,
    this.isFlexible,
    required this.onSubmit,
  });

  final String? name;
  final String? description;
  final int? duration;
  final bool? isFlexible;
  final Function(String, String, bool, int) onSubmit;

  @override
  State<CreateNewExcerciseModal> createState() =>
      _CreateNewExcerciseModalState();
}

class _CreateNewExcerciseModalState extends State<CreateNewExcerciseModal> {
  final _formKey = GlobalKey<FormState>();
  bool _focusDuration = false;
  Duration _duration = Duration.zero;
  bool _isTemporized = false;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _setUpControllers();
  }

  void _setUpControllers() {
    if (widget.name == null) {
      _nameController = TextEditingController();
    } else {
      _nameController = TextEditingController(text: widget.name);
    }

    if (widget.description == null) {
      _descriptionController = TextEditingController();
    } else {
      _descriptionController = TextEditingController(text: widget.description);
    }

    if (widget.duration == null) {
      _duration = Duration.zero;
    } else {
      _duration = Duration(seconds: widget.duration!);
    }

    if (widget.isFlexible == null) {
      _isTemporized = false;
    } else {
      _isTemporized = !widget.isFlexible!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createNew(BuildContext context) {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    if (_isTemporized && _duration == Duration.zero) {
      setState(() => _focusDuration = true);
      return;
    }

    final name = _nameController.text;
    final description = _descriptionController.text;

    widget.onSubmit(name, description, !_isTemporized, _duration.inSeconds);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _setDuration(BuildContext context) async {
    final resultingDuration = await showDurationPicker(
        context: context, initialTime: _duration, baseUnit: BaseUnit.second);
    if (resultingDuration != null) {
      setState(() => _duration = resultingDuration);
    }
  }

  String _formatDurationToPrint(Duration duration) {
    final seconds = duration.inSeconds;
    final minutes = (seconds / 60).floor();
    return "$minutes:${seconds - (minutes * 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.modalBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Crear nuevo ejercicio",
              style: context.textTheme.labelLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextInput(
              backgroundColor: AppColors.modalBackground,
              controller: _nameController,
              hintText: "Nombre",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo requerido";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextInput(
              backgroundColor: AppColors.modalBackground,
              controller: _descriptionController,
              hintText: "Descripción",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo requerido";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Temporizador:",
                  style: context.textTheme.bodyMedium,
                ),
                Switch.adaptive(
                    focusColor: AppColors.primary,
                    value: _isTemporized,
                    onChanged: (value) =>
                        setState(() => _isTemporized = value)),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Duración:",
                  style: context.textTheme.bodyMedium,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: _focusDuration
                            ? AppColors.redPrimary
                            : Colors.white24,
                      ),
                      shape: BoxShape.circle),
                  child: IconButton(
                      disabledColor: AppColors.extraQuinary,
                      highlightColor: AppColors.extraPrimary.withOpacity(0.5),
                      iconSize: 32.0,
                      onPressed:
                          _isTemporized ? () => _setDuration(context) : null,
                      icon: !_isTemporized || _duration == Duration.zero
                          ? const Icon(Icons.alarm)
                          : Text(
                              _formatDurationToPrint(_duration),
                              style: context.textTheme.labelMedium,
                            )),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(text: "Crear", onPressed: () => _createNew(context))
          ],
        ),
      ),
    );
  }
}
