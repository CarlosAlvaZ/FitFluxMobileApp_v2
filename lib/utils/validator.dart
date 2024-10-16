///
/// Validator copied from [ https://github.com/ArefMozafari/flutter_pw_validator/ ]
///
class Validator {
  /// Checks if password has minLength
  static bool hasMinLength(String password, int minLength) {
    return password.length >= minLength ? true : false;
  }

  /// Checks if [ password ] has at least [ normalCount ] char letter matches
  static bool hasMinNormalChar(String password, int normalCount) {
    String pattern = '^(.*?[A-Z]){' + normalCount.toString() + ',}';
    return password.toUpperCase().contains(RegExp(pattern));
  }

  /// Checks if [ password ] has at least [ uppercaseCount ] uppercase letter matches
  static bool hasMinUppercase(String password, int uppercaseCount) {
    String pattern = '^(.*?[A-Z]){' + uppercaseCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  /// Checks if [ password ] has at least [ lowercaseCount ] lowercase letter matches
  static bool hasMinLowercase(String password, int lowercaseCount) {
    String pattern = '^(.*?[a-z]){' + lowercaseCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  /// Checks if [ password ] has at least [ numericCount ] numeric character matches
  static bool hasMinNumericChar(String password, int numericCount) {
    String pattern = '^(.*?[0-9]){' + numericCount.toString() + ',}';
    return password.contains(RegExp(pattern));
  }

  /// Checks if [ password ] has at least [ specialCount ] special character matches
  static bool hasMinSpecialChar(String password, int specialCount) {
    String pattern =
        r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){" + specialCount.toString() + ",}";
    return password.contains(RegExp(pattern));
  }
}

