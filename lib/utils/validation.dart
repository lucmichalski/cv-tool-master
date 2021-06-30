import 'package:flutter/material.dart';

class Validation {
  // Regex for email
  bool _isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

// Check valid email
  String checkValidEmailField(BuildContext context, String email) {
    if (email.isEmpty) {
      return 'Email can not be empty';
    } else if (email.length > 30) {
      return 'Email\'s maximum 30 characters';
    } else if (!_isValidEmail(email) ||
        email[0] == '.' ||
        email[0] == '-' ||
        email[0] == '_') {
      return 'Email invalid';
    } else {
      return null;
    }
  }
  String checkValidNameField(BuildContext context, String name) {
    if (name.isEmpty) {
      return 'Name can not be empty';
    } else if (name.length < 2) {
      return 'Name phải có tối thiểu 3 ký tự';
    } else if (name.length > 30) {
      return 'Name chỉ có tối đa 30 ký tự';
    } else {
      return null;
    }
  }

  // Check valid password
  String checkValidPassword(BuildContext context, String password) {
    RegExp hasUpperCase = RegExp(r'.*[A-Z].*', multiLine: false);
    RegExp hasLowerCase = RegExp(r'.*[a-z].*', multiLine: false);
    RegExp hasNumber = RegExp(r'.*[0-9].*', multiLine: false);
    RegExp hasSpecial = new RegExp(
      // r'.*[!@#$%^&*(),.?:{}|<>].*"',
      r"[-!$%^&*()_+|~=`{}#@\[\]:;'’<>?,.\/"
      '"”'
      "]",
      caseSensitive: false,
      multiLine: false,
    );
    if (password.isEmpty) {
      return 'Password can not be empty';
    } else if (password.length < 8) {
      return 'Password must have at least 8 characters';
    } else if (!hasUpperCase.hasMatch(password)) {
      return 'Password must have at least 1 upper case character';
    } else if (!hasLowerCase.hasMatch(password)) {
      return 'Password must have at least 1 normal case character';
    } else if (!hasSpecial.hasMatch(password)) {
      return 'Password must have at least 1 special character';
    } else if (!hasNumber.hasMatch(password)) {
      return 'Password must have at least 1 numeric character';
    } else {
      return null;
    }
  }

  // Check password confirmed
  String checkPasswordConfirmed(BuildContext context, String password, String pswConfirmed) {
    if (password != pswConfirmed) {
      return 'Password does not match';
    } else {
      return null;
    }
  }
}
