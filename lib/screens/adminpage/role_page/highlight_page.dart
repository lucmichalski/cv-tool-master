import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/master_bloc.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

class HighlightPage extends StatefulWidget {
  final MasterData masterData;
  final Function onPrevious;

  const HighlightPage({this.masterData, this.onPrevious});

  @override
  _HighlightPageState createState() => _HighlightPageState();
}

class _HighlightPageState extends State<HighlightPage> {
  Map<String, TextEditingController> _highlightController = {};

  @override
  void initState() {
    if (widget.masterData.technicalUsed.isEmpty)
      widget.masterData.technicalUsed.add('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 15),
            child: HorizontalLine('Technical'),
          ),
          _buildTechnicalList(context),
          AddButton(
            isButtonText: true,
            textButton: 'ADD TECHNICAL USED',
            onPressed: () {
              setState(() {
                widget.masterData.technicalUsed.add('');
              });
            },
          ),
          SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => widget.onPrevious(),
                  child: Text(
                    'PREVIOUS',
                    style: CommonStyle.white700Size22(context)
                        .copyWith(color: Colors.grey),
                  )),
              ButtonCommon(buttonText: 'SAVE', onClick: () async {
                final String requestBody = json.encoder.convert(widget.masterData);
                final pref = await SharedPreferencesService.instance;
                BlocProvider.of<MasterBloc>(context).add(RequestAddMasterEvent(pref.getAccessToken,requestBody));
                print(requestBody);
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTechnicalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
          children: List.generate(
              widget.masterData.technicalUsed.length,
              (index) => _buildTechnicalItem(
                  context,
                  widget.masterData.technicalUsed,
                  widget.masterData.technicalUsed[index],
                  index))),
    );
  }

  Widget _buildTechnicalItem(
      BuildContext context, List<String> technical, String value, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              controller: _generateController('highlight-$index', value),
              onChanged: (values) {
                setState(() {
                  widget.masterData.technicalUsed[index] = values;
                });
              },
            ),
          ),
          DeleteButton(
            onPressed: () {
              setState(() {
                technical.removeAt(index);
              });
            },
          )
        ],
      ),
    );
  }

  TextEditingController _generateController(String id, String value) {
    var key = id;
    TextEditingController controller = _highlightController[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // // Set text
    controller.text = value;
    // Set cursor
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _highlightController[key] = controller;
    return controller;
  }
}
