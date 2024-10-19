import 'package:duration_picker/duration_picker.dart';
import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/models/excercise.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_button.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_text_input.dart';
import 'package:flutter/material.dart';

class CreateNewExcerciseModal extends StatefulWidget {
  const CreateNewExcerciseModal({
    super.key,
    this.excercise,
    this.buttonText = "Crear",
    required this.onSubmit, required this.modalTitle,
  });

  final Excercise? excercise;
  final String buttonText;
  final Function(Excercise) onSubmit;
  final String modalTitle;

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
    if (widget.excercise == null) {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _duration = Duration.zero;
      _isTemporized = false;
    } else {
      _nameController = TextEditingController(text: widget.excercise!.name);
      _descriptionController =
          TextEditingController(text: widget.excercise!.description);
      _duration = Duration(seconds: widget.excercise!.duration);
      _isTemporized = !widget.excercise!.isFlexible;
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

    widget.onSubmit(Excercise(
        widget.excercise == null ? "" : widget.excercise!.id,
        name,
        description,
        !_isTemporized,
        _duration.inSeconds,
        "",
        0));
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
              widget.modalTitle,
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
            CustomButton(
                text: widget.buttonText, onPressed: () => _createNew(context))
          ],
        ),
      ),
    );
  }
}
