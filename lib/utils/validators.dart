// validators.dart

/// Validates a roll number
bool validateRollNumber(String rollNumber) {
  return RegExp(r'^[0-9]{1,6}\$').hasMatch(rollNumber);
}

/// Validates a registration number
bool validateRegistrationNumber(String regNumber) {
  return RegExp(r'^[A-Z]{2}[0-9]{4}\$').hasMatch(regNumber);
}

/// Validates a phone number
bool validatePhone(String phone) {
  return RegExp(r'^\+?[0-9]{10,15}\$').hasMatch(phone);
}

/// Validates an email address
bool validateEmail(String email) {
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$').hasMatch(email);
}

/// Validates a password
bool validatePassword(String password) {
  return password.length >= 8;
}