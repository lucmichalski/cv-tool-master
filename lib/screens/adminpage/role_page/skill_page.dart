import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';

class SkillPage extends StatefulWidget {
  final MasterData masterData;
  SkillPage({this.masterData});

  @override
  _SkillPageState createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  Map<String, TextEditingController> _skillController = {};

  @override
  void initState() {
    if (widget.masterData.skills.isEmpty) widget.masterData.skills.add('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15),
              child: HorizontalLine('Skill'),
            ),
            _buildSkill(context),
            AddButton(
              isButtonText: true,
              textButton: 'ADD SKILL',
              onPressed: () {
                setState(() {
                  widget.masterData.skills.add('');
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSkill(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: widget.masterData.skills
            .map((e) => _buildSkillItem(context, widget.masterData.skills, e,
                widget.masterData.skills.indexOf(e)))
            .toList(),
      ),
    );
  }

  Widget _buildSkillItem(
      BuildContext context, List<String> skillList, String value, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              controller: _generateController('skill-$index', value),
              onChanged: (value) {
                setState(() {
                  widget.masterData.skills[index] = value;
                });
              },
            ),
          ),
          DeleteButton(
            onPressed: () {
              setState(() {
                skillList.removeAt(index);
              });
            },
          )
        ],
      ),
    );
  }

  TextEditingController _generateController(String id, String value) {
    var key = id;
    TextEditingController controller = _skillController[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    controller.text = value;
    _skillController[key] = controller;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return controller;
  }
}