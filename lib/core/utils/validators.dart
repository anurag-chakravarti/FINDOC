final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
final _passwordRe =
RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');

String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  if (!_emailRe.hasMatch(v.trim())) return 'Enter a valid email address';
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (!_passwordRe.hasMatch(v)) {
    return 'Min 8 chars, with upper, lower, number & symbol';
  }
  return null;
}