import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';

class HighlightPage extends StatefulWidget {
  final MasterData masterData;
  const HighlightPage({this.masterData});

  @override
  _HighlightPageState createState() => _HighlightPageState();
}

class _HighlightPageState extends State<HighlightPage> {
  Map<String, TextEditingController> _highlightController = {};

  @override
  void initState() {
    if (widget.masterData.technology.isEmpty)
      widget.masterData.technology.add('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                  widget.masterData.technology.add('');
                });
              },
            )
          ],
        ),
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
        children: widget.masterData.technology
            .map((e) => _buildTechnicalItem(
                context,
                widget.masterData.technology,
                e,
                widget.masterData.technology.indexOf(e)))
            .toList(),
      ),
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
              onChanged: (value) {
                setState(() {
                  widget.masterData.technology[index] = value;
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
    controller.text = value;
    _highlightController[key] = controller;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return controller;
  }
}
