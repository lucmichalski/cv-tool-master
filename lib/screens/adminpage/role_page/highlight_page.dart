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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30.0,),
            HorizontalLine('Technical'),
            SizedBox(height: 15.0,),
            _buildSkill(context),
            AddButton(onPressed: (){
              setState(() {
                widget.masterData.technology.add('');
              });
            },)
          ],
        ),
      ),
    );
  }
  Widget _buildSkill(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        children:widget.masterData.technology.map((e) => _buildSkillItem(context, widget.masterData.technology, e, widget.masterData.technology.indexOf(e))).toList(),
      ),
    );
  }
  Widget _buildSkillItem(BuildContext context , List<String> technical,String value , int index){
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(label: 'Technical',controller: _generateController('highlight-$index', value),onChanged: (value){
              setState(() {
                widget.masterData.technology[index] = value;
              });
            },),
          ),
          DeleteButton(onPressed: (){
            setState(() {
              technical.removeAt(index);
            });
          },)
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
