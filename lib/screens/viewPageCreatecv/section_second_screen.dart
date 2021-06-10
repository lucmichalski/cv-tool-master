import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  CVModel _cvModel;
  List<Education> _education =[];
  List<String> _listEducation = [];
  List<String> _listSchools =[];
  List<String> _listMajors =[];
  List<String> _educationYear = ['2015','2016','2017','2018','2019','2020','2021'
  ];
  List<String> _skillsList = [];
  List<String> _skillsData =['Programing Language' ,'Nodejs ,php ,Python'];
  Map<String, TextEditingController> _controllerMap = {};
  int _yearSelected =0;
  TextEditingController _schoolController =TextEditingController();
  TextEditingController _majorsController =TextEditingController();
  @override
  void initState() {
    _listEducation = _educationYear;

    //_listEducation = _cvModel.education.year;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double marginleft = MediaQuery.of(context).size.width*0.15;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              HorirontalLine('EDUCATION'),
              SizedBox(height: 20,),
              _buildEducation(context),
              HorirontalLine('Skill'),
              SizedBox(height: 20,),
              _buildSkill(context),
            ],
          ),
        ),
      ),
    );
  }
  TextEditingController _generateController(String id, String value) {
    var key = id;
    var controller = _controllerMap[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // Set text
    controller.text = value;
    // Set cursor
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerMap[key] = controller;
    return controller;
  }
  Widget _buildEducation(BuildContext context)
  {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
          itemCount: _education.length,
            itemBuilder: (context , index){
            final item = _education[index];
         // return _buildEducationItem(context, item, index);
        }),
        IconButton(
            onPressed: () {
              setState(() {
                _education.add(Education());
              });
            },
            icon: Icon(
              Icons.add_circle_outline,
              size: 30.0,
              color: kmainColor,
            )),
      ],
    );
  }
  Widget _buildEducationItem(BuildContext context , String school , String majors , int index)
  {
    return Container(
      margin: EdgeInsets.only(bottom: 30,left: MediaQuery.of(context).size.width*0.15),
      child: Column(
        children: [
          InputTextFormfield('', _generateController('school-${index}',school)),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                flex: 8,
                  child: InputTextFormfield('',_generateController('majors-$index}',majors))),
              SizedBox(width: 7,),
              ControlTypeDropDown(
                menuList: _educationYear,
                initPosition: _yearSelected,
                onChange: (val) {
                  setState(() {
                    _yearSelected = val;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildSkill(BuildContext context)
  {
    return ListView.builder(
        shrinkWrap: true,
      itemCount: _skillsData.length,
        itemBuilder: (context , index){
        final item  = _skillsData[index];
      return _buildSkillsItem(context, item, index);
    });
  }
  Widget _buildSkillsItem(BuildContext context ,String skill , int index )
  {
    return Container(
      margin:  EdgeInsets.only(bottom: 30),
      height: 150,
    decoration: BoxDecoration(
      border:  Border.all(width: 1.0, color:Colors.black)
    ),
    );
  }
}
