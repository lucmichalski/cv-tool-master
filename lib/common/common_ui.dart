import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/extensions/size_extension.dart';

class ButtonCommon extends StatefulWidget {
  final double borderRadius;
  final double height;
  final EdgeInsetsGeometry padding;
  final String buttonText;
  final TextStyle textStyle;
  final Function onClick;
  final Color color;
  final Gradient gradient;
  final double width;
  final bool isCircle;
  final bool isLoading;
  ButtonCommon(
      {this.borderRadius,
      this.height,
      this.width,
      this.isCircle,
      @required this.buttonText,
      this.textStyle,
      this.padding,
      this.gradient,
      this.color,
      this.isLoading = false,
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
      borderRadius:
          BorderRadius.all(Radius.circular(this.widget.borderRadius ?? 10)),
      color: widget.color ?? kmainColor,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(this.widget.borderRadius ?? w * 0.005),
        ),
        onTap: () {
          widget.onClick();
        },
        child: Container(
          width: widget.width,
          padding: EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          height: this.widget.height ?? (h * 0.06),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(this.widget.borderRadius ?? 10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.widget.buttonText,
                style: widget.textStyle ?? CommonStyle.white700Size22(context),
              ),
              Visibility(
                visible: widget.isLoading,
                child: Padding(
                  padding: EdgeInsets.only(left: w * 0.01),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.transparent,
                  ),
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
  final double textSize;
  LinkText(
      {@required this.text,
      this.linkTextStyle,
      @required this.onTapLink,
      this.textSize});

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
                    fontSize:
                        DoubleExt(widget.textSize ?? 18).textSize(context),
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
class InputTextFormfield extends StatelessWidget{
 final String labelText;
 final TextEditingController controller ;
  const InputTextFormfield(this.labelText, this.controller);
  @override
  Widget build(BuildContext context) {
   return Container(
     height: 40,
     child: TextFormField(
       controller: controller,
       decoration: InputDecoration(
         labelText: labelText,
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
class HorirontalLine extends StatelessWidget {
  final String title;

  const HorirontalLine(this.title);

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
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width/ 4),
              child: Divider(color: Colors.black)),
        ],
      ),
    );
  }
}

class FormInputData extends StatelessWidget{
  TextEditingController controller ;
  String onChangedt;
  FormInputData(this.controller,this.onChangedt);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextFormField(
        onChanged: (val)
        {
          onChangedt = val;
          print(onChangedt);
        },
        controller: controller,
        decoration: InputDecoration(
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


