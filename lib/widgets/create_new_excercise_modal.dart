import 'package:fit_flux_mobile_app_v2/appcolors.dart';
import 'package:fit_flux_mobile_app_v2/constants.dart';
import 'package:fit_flux_mobile_app_v2/widgets/custom_text_input.dart';
import 'package:flutter/material.dart';

class CreateNewExcerciseModal extends StatefulWidget {
  const CreateNewExcerciseModal({
    super.key,
  });

  @override
  State<CreateNewExcerciseModal> createState() =>
      _CreateNewExcerciseModalState();
}

class _CreateNewExcerciseModalState extends State<CreateNewExcerciseModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createNew() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    final name = _nameController.text;
    final description = _descriptionController.text;
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
            )
          ],
        ),
      ),
    );
  }
}
