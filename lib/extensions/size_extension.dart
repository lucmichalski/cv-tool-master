import 'package:flutter/material.dart';

extension DoubleExt on double {
  static const standardWidth = 1920.0;
  static const standardHeight = 1080.0;

  double textSize(BuildContext context) {
    var ratio = this * MediaQuery.of(context).size.width / standardWidth;
    return ratio;
  }

  double textSizePdf(BuildContext context) {
    var ratio = this * MediaQuery.of(context).size.width / standardWidth;
    return ratio * 2;
  }

  // double width() {
  //   return (this / standardWidth * 100).w;
  // }

  // double height() {
  //   return (this / standardHeight * 100).h;
  // }
}
