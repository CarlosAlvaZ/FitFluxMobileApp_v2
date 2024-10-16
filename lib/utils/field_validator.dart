import 'package:email_validator/email_validator.dart';
import 'package:fit_flux_mobile_app_v2/utils/validator.dart';

class FieldValidator {
  static String? validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo Requerido';
    } else if (!EmailValidator.validate(value)) {
      return 'Por favor, ingrese un email valido';
    }
    return null;
  }

  static String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    } else if (!Validator.hasMinLength(value, 8)) {
      return 'La contraseña debe tener al menos 8 caracteres';
    } else if (!Validator.hasMinSpecialChar(value, 1)) {
      return 'La contraseña debe contener al menos 1 caracter especial';
    } else if (!Validator.hasMinNumericChar(value, 1)) {
      return 'La contraseña debe contener al menos 1 número';
    } else if (!Validator.hasMinUppercase(value, 1)) {
      return 'La contraseña debe tener al menos una letra mayúscula';
    } else if (!Validator.hasMinLowercase(value, 1)) {
      return 'La contraseña debe tener al menos una letra minúscula';
    }
    return null;
  }
}
