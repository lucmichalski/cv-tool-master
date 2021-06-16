import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
class SkillPage extends StatefulWidget {
  final MasterData masterData;
  const SkillPage({this.masterData});

  @override
  _SkillPageState createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
 Map<String , TextEditingController> _skillController = {};
 @override
  void initState() {
    // TODO: implement initState
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30.0,),
            HorizontalLine('Skill'),
            SizedBox(height: 15.0,),
            _buildSkill(context),
            AddButton(onPressed: (){
              setState(() {
                widget.masterData.skills.add('');
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
        children:widget.masterData.skills.map((e) => _buildSkillItem(context, widget.masterData.skills, e, widget.masterData.skills.indexOf(e))).toList(),
      ),
    );
  }
  Widget _buildSkillItem(BuildContext context , List<String> skillList,String value , int index){
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(label: 'Skill',controller: _generateController('skill-$index', value),onChanged: (value){
              setState(() {
                widget.masterData.skills[index] = value;
              });
            },),
          ),
          DeleteButton(onPressed: (){
            setState(() {
              skillList.removeAt(index);
            });
          },)
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
