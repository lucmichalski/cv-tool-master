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
      return 'Email không thể để trống';
    } else if (email.length < 2) {
      return 'Email phải có tối thiểu 3 ký tự';
    } else if (email.length > 30) {
      return 'Email chỉ có tối đa 30 ký tự';
    } else if (!_isValidEmail(email) ||
        email[0] == '.' ||
        email[0] == '-' ||
        email[0] == '_') {
      return 'Email không hợp lệ';
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
      return 'Mật khẩu không thể để trống';
    } else if (password.length < 8) {
      return 'Mật khẩu phải tối thiểu 8 ký tự';
    } else if (!hasUpperCase.hasMatch(password)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự viết hoa';
    } else if (!hasLowerCase.hasMatch(password)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự viết thường';
    } else if (!hasSpecial.hasMatch(password)) {
      return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
    } else if (!hasNumber.hasMatch(password)) {
      return 'Mật khẩu phải có ít nhất 1 con số';
    } else {
      return null;
    }
  }
}
