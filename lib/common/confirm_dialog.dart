import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';

class ConfirmDialog extends StatefulWidget {
  final Function onDeleteConfirmed;

  const ConfirmDialog({Key key, this.onDeleteConfirmed}) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return new BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: w * 0.35),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
                'Caution',
                style: CommonStyle.grey900Size48(context),
              ),
              Spacer(),
              IconButton(
                  hoverColor: Color(0xff5C5C5C),
                  icon: Icon(
                    Icons.close_rounded,
                    size: w * 0.015,
                  ),
                  onPressed: () => Navigator.pop(context))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: w * 0.02),
            child: Text(
              'Are you sure want to delete this CV',
              style: CommonStyle.size22W4005c5c5c(context),
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: ButtonCommon(
                      color: Color(0xffe3f2fd),
                      buttonText: 'CANCEL',
                      textStyle: CommonStyle.white700Size22(context).copyWith(color: Color(0xff4a4a4a)),
                      onClick: () => Navigator.pop(context))),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: ButtonCommon(
                      color: Colors.red,
                      buttonText: 'OK',
                      onClick: () {
                        widget.onDeleteConfirmed();
                        Navigator.pop(context);
                      })),
            ],
          )
        ],
      ),
    );
  }
}
