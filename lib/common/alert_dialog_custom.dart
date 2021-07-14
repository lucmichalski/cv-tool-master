import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

class AlertDialogCustom extends StatelessWidget {
  final String title;
  final String message;
  final Function function;
  final bool isHideCloseBtn;
  final Function functionClose;

  AlertDialogCustom({this.title, @required this.message, this.function,this.functionClose, this.isHideCloseBtn = false});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: w * 0.35),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(w * 0.01)),
          backgroundColor: Colors.transparent.withOpacity(0.8),
          child: _dialogContent(context),
        ));
  }

  Widget _dialogContent(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.02),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(w * 0.01),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                this.title ?? 'Lỗi',
                style: CommonStyle.grey900Size48(context),
              ),
              Spacer(),
              Visibility(
                visible: !this.isHideCloseBtn,
                child: IconButton(
                    hoverColor: Color(0xff5C5C5C),
                    icon: Icon(
                      Icons.close_rounded,
                      size: w * 0.015,
                    ),
                    onPressed: () => Navigator.pop(context)),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.02),
            child: Text(
              this.message ?? kEmpty,
              style: CommonStyle.size22W4005c5c5c(context),
            ),
          ),
          ButtonCommon(buttonText: 'OK', onClick: this.function)
        ],
      ),
    );
  }
}
void showAlertDialog(
    BuildContext context, String title, String msg, Function func) async {
  var message = msg.contains('Exception: ') ? msg.replaceAll('Exception: ', '') : msg;
  if (message.toLowerCase().contains('token')) {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialogCustom(
              title: title,
              message: message,
              isHideCloseBtn: true,
              function: () async {
                final pref = await SharedPreferencesService.instance;
                pref.removeAccessToken();
                pref.removeUserNm();
                navKey.currentState
                  .pushNamedAndRemoveUntil(routeLogin, (route) => false);
              });
        });
  } else if (message.toLowerCase().contains('xmlhttprequest')) {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialogCustom(
              title: title,
              message: 'Server Down',
              function: () => Navigator.pop(context));
        });
  // } else if(message.toLowerCase().contains('Error') || message.toLowerCase().contains('token đã hết hạn')){
  //   await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AlertDialogCustom(
  //             title: title,
  //             message: message,
  //             isHideCloseBtn:true,
  //             function: () async {
  //               final pref = await SharedPreferencesService.instance;
  //               pref.removeAccessToken();
  //               pref.removeUserNm();
  //               navKey.currentState
  //                   .pushNamedAndRemoveUntil(routeLogin, (route) => false);
  //             });
  //       });
  }
  else {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialogCustom(title: title, message: message, function: func);
        });
  }
  // msg.contains('Socket')
  //     ? displaySnackBarMessage(context, 'Mất kết nối internet', "ic_offline")
  //     :
}
