import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomProgressBar extends StatelessWidget {
  CustomProgressBar();

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: dialogBackgroundColor.withOpacity(dialogBackgroundOpacity),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 0.0),
        backgroundColor: Colors.transparent,
        child: _dialogContent(context),
      ),
    );
  }

  _dialogContent(BuildContext parentContext) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation(progressBarColor),
      ),
    );
  }
}

// show progress bar dialog
showProgressBar(BuildContext context, bool show) {
  if (show) {
    EasyLoading.show();
  } else {
    EasyLoading.dismiss(animation: true);
  }
}
