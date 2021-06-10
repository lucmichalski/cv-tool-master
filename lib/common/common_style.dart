import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cv_maker/extensions/size_extension.dart';

class CommonStyle {
  static TextStyle grey400Size22(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(22).textSize(context),
        fontWeight: FontWeight.w400,
        color: Color(0xff5C5C5C));
  }

  static TextStyle grey400Size30(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(30).textSize(context),
        fontWeight: FontWeight.w400,
        color: Color(0xff5C5C5C));
  }

  static TextStyle black400Size22(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(22).textSize(context),
        fontWeight: FontWeight.w500,
        color: Colors.black);
  }

  static TextStyle white700Size22(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(22).textSize(context),
        fontWeight: FontWeight.w700,
        color: Colors.white);
  }

  static TextStyle main700Size18(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(18).textSize(context),
        fontWeight: FontWeight.w700,
        color: kmainColor);
  }

  static TextStyle grey900Size48(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(48).textSize(context),
        fontWeight: FontWeight.w900,
        color: Color(0xff5C5C5C));
  }

  static TextStyle size22W4005c5c5c(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(22).textSize(context),
        fontWeight: FontWeight.w700,
        color: Color(0xff5C5C5C));
  }

  static TextStyle size48W700black(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(48).textSize(context),
        fontWeight: FontWeight.w700,
        color: Colors.black);
  }
  static TextStyle size20W400black(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(20).textSize(context),
        fontWeight: FontWeight.w400,
        color: Colors.black);
  }
  static TextStyle size32W600black(BuildContext context) {
    return GoogleFonts.roboto(
        fontSize: DoubleExt(32).textSize(context),
        fontWeight: FontWeight.w600,
        color: Colors.black);
  }
}