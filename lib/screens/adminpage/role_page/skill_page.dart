import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';

class SkillPage extends StatefulWidget {
  final MasterData masterData;
  final Function onPrevious;
  final Function onNext;

  SkillPage({this.masterData, this.onPrevious, this.onNext});

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 15),
            child: HorizontalLine('Skill'),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Color(0xFFedf4ff),
                border: Border.all(color: Color(0xffccdfff), width: 1)),
            child: Row(
              children: [
                Icon(
                  Icons.text_snippet_outlined,
                  color: kmainColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                    'Example: Programming Language, Framework/Library, Operating System,...',
                    style: CommonStyle.size16W400hintTitle(context)
                        .copyWith(color: Color(0xff5869a2)))
              ],
            ),
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
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildSkill(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
          children: List.generate(
              widget.masterData.skills.length,
              (index) => _buildSkillItem(context, widget.masterData.skills,
                  widget.masterData.skills[index], index))),
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
    TextSelection previousSelection = controller.selection;
    controller.text = value;
    controller.selection = previousSelection;
    _skillController[key] = controller;
    return controller;
  }
}
