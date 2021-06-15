import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/extensions/size_extension.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

class ButtonCommon extends StatefulWidget {
  final double borderRadius;
  final double height;
  final Icon icon;
  final EdgeInsetsGeometry padding;
  final String buttonText;
  final TextStyle textStyle;
  final Function onClick;
  final Color color;
  final Gradient gradient;
  final double width;
  final bool isCircle;

  ButtonCommon(
      {this.borderRadius,
      this.height,
      this.icon,
      this.width,
      this.isCircle,
      @required this.buttonText,
      this.textStyle,
      this.padding,
      this.gradient,
      this.color,
      @required this.onClick});

  @override
  _ButtonCommonState createState() => _ButtonCommonState();
}

class _ButtonCommonState extends State<ButtonCommon> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: BorderRadius.all(
          Radius.circular(this.widget.borderRadius ?? w * 0.001)),
      color: widget.color ?? kmainColor,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(this.widget.borderRadius ?? w * 0.001),
        ),
        onTap: () {
          widget.onClick();
        },
        child: Container(
          width: widget.width,
          padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(this.widget.borderRadius ?? w * 0.001)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.widget.buttonText,
                style: widget.textStyle ?? CommonStyle.white700Size22(context),
              ),
              Visibility(
                visible: widget.icon != null,
                child: Padding(
                  padding: EdgeInsets.only(left: w * 0.005),
                  child: widget.icon,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LinkText extends StatefulWidget {
  final String text;
  final TextStyle linkTextStyle;
  final Function onTapLink;
  final Color color;

  LinkText(
      {@required this.text,
      this.linkTextStyle,
      @required this.onTapLink,
      this.color});

  @override
  _LinkTextState createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onHover: (event) => setState(() {
              _isHover = true;
            }),
        onExit: (event) => setState(() {
              _isHover = false;
            }),
        child: GestureDetector(
          onTap: () => widget.onTapLink(),
          child: Text(
            this.widget.text,
            style: widget.linkTextStyle ??
                CommonStyle.main700Size18(context).copyWith(
                    color: widget.color,
                    decoration: _isHover
                        ? TextDecoration.underline
                        : TextDecoration.none),
          ),
        ));
  }
}

class ControlTypeDropDown extends StatefulWidget {
  final Function onChange;
  final int initPosition;
  final bool isSpecial;
  final List<String> menuList;

  ControlTypeDropDown(
      {this.initPosition,
      this.onChange,
      this.isSpecial = true,
      @required this.menuList});

  @override
  _ControlTypeDropDownState createState() => _ControlTypeDropDownState();
}

class _ControlTypeDropDownState extends State<ControlTypeDropDown> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final widgets = widget.menuList
        .map((x) => DropdownMenuItem(
              child: Text(
                x,
                style: CommonStyle.black400Size22(context),
              ),
              value: widget.menuList.indexOf(x),
            ))
        .toList();
    return Container(
      // height: w * 0.05,
      padding: EdgeInsets.symmetric(horizontal: w * 0.01),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.005),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Colors.black)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            value: widget.initPosition,
            focusColor: Color(0xffDBF4FF),
            iconEnabledColor: Theme.of(context).iconTheme.color,
            items: widgets,
            onChanged: (value) => this.widget.onChange(value)),
      ),
    );
  }
}

class SkillDropDown extends StatefulWidget {
  final Function onChange;
  final int initPosition;
  final List<Skill> menuList;

  const SkillDropDown({this.onChange, this.initPosition, this.menuList});

  @override
  _SkillDropDownState createState() => _SkillDropDownState();
}

class _SkillDropDownState extends State<SkillDropDown> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final widgets = widget.menuList
        .map((x) => DropdownMenuItem(
              child: Container(
                width: w * 0.22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      x.skillNm,
                      style: CommonStyle.black400Size12(context),
                    ),
                    x.isSelected ? Spacer() : Container(),
                    x.isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: kmainColor,
                            size: 16,
                          )
                        : Container()
                  ],
                ),
              ),
              value: widget.menuList.indexOf(x),
            ))
        .toList();
    return Container(
      // height: w * 0.05,
      padding: EdgeInsets.symmetric(horizontal: w * 0.01),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.005),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Colors.black)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            value: widget.initPosition,
            focusColor: Color(0xffDBF4FF),
            iconEnabledColor: Theme.of(context).iconTheme.color,
            items: widgets,
            onChanged: (value) => this.widget.onChange(value)),
      ),
    );
  }
}

class InputTextFormfield extends StatelessWidget {
  String labelText;
  TextEditingController controller;

  String errorText;

  InputTextFormfield(this.labelText, this.controller, this.errorText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorText;
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalLine extends StatelessWidget {
  final String title;

  const HorizontalLine(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CommonStyle.size32W600black(context),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Container(
              margin:
                  EdgeInsets.only(right: MediaQuery.of(context).size.width / 4),
              child: Divider(color: Colors.black)),
        ],
      ),
    );
  }
}

class TextFieldCommon extends StatelessWidget {
  final int maxLines;
  final String hint;
  final String label;
  final TextStyle hintStyle;
  final bool isObscure;
  final Function onChanged;
  final FocusNode focusNode;
  final Function(String value) validator;
  final BorderRadiusGeometry borderRadius;
  final TextEditingController controller;
  final EdgeInsetsGeometry contentPadding;

  TextFieldCommon(
      {this.hint,
      this.hintStyle,
      this.isObscure = false,
      this.focusNode,
      this.validator,
      this.borderRadius,
      this.controller,
      this.label,
      this.maxLines,
      this.contentPadding,
      this.onChanged(String value)});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      // height: 35,
      child: TextFormField(
        maxLines: maxLines,
        onChanged: onChanged,
        focusNode: focusNode ?? FocusNode(),
        controller: controller,
        cursorColor: kmainColor,
        obscureText: this.isObscure,
        validator: this.validator,
        decoration: new InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label ?? kEmpty,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.001),
            borderSide: BorderSide(
              color: kmainColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.001),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.001),
            borderSide: BorderSide(
              color: mainBorderColor,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.001),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(w * 0.001),
            borderSide: BorderSide(
              color: mainBorderColor.withOpacity(0.6),
              width: 1.0,
            ),
          ),
          contentPadding:
              contentPadding ?? EdgeInsets.symmetric(horizontal: 15),
          // hintText: this.hint ?? kEmpty,
          // hintStyle: this.hintStyle ?? CommonStyle.size22W4005c5c5c(context)
        ),
      ),
    );
  }
}

class RichTextCommon extends StatelessWidget {
  final String boldText;
  final String regularText;
  final double size;

  const RichTextCommon({this.boldText, this.regularText, this.size});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: '$boldText',
          style: size == 14
              ? CommonStyle.size14W700black(context)
              : CommonStyle.size12W700black(context)),
      TextSpan(
          text: '$regularText',
          style: size == 14
              ? CommonStyle.size14W400black(context)
              : CommonStyle.size12W400black(context)),
    ]));
  }
}

class Bullet extends StatelessWidget {
  final String text;
  final bool isFill;

  const Bullet({this.text, this.isFill = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isFill
            ? Icon(
                Icons.circle,
                color: Colors.black,
                size: 8,
              )
            : Icon(
                Icons.circle_outlined,
                color: Colors.black,
                size: 8,
              ),
        SizedBox(width: 16.0),
        Text(
          '$text',
          style: CommonStyle.size12W400black(context),
        )
      ],
    );
  }
}
