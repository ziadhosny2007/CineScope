import 'package:flutter/material.dart';

class Validators {
  static String? email(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  // للـ login: يكفي إنه مش فاضي
  static String? requiredPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    return null;
  }

  // للـ sign up: قواعد أقوى
  static String? newPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'At least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(v) || !RegExp(r'\d').hasMatch(v)) {
      return 'Use letters and numbers';
    }
    return null;
  }
  

static String? Function(String?) confirmPassword(TextEditingController original) {
  return (String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != original.text) return 'Passwords do not match';
    return null;
  };
}

  static String? name(String? v) {
    if (v == null || v.trim().length < 2) return 'Enter your name';
    return null;
  }
}
