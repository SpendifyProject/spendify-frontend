class Validator{
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    if (value[0] != '0') {
      return 'Phone number must start with 0';
    }
    if (value[1] != '2' && value[1] != '5') {
      return 'The second digit must be 2 or 5';
    }
    const pattern = r'^[0-9]+$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Phone number must contain only numbers';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    const pattern = r'^[a-zA-Z\s\-]+$';
    final regExp = RegExp(pattern);if (!regExp.hasMatch(value)) {
      return 'Full name can only contain letters, hyphens, and spaces';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    const pattern = r'^(?!0\d)(\d+|\d*\.\d{1,2})$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Invalid amount format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    const pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Password must be at least 8 characters long and include letters, numbers, and special characters';
    }
    return null;
  }
}