import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:intl/intl.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  CVModel _cvModel;
  String year;
  List<Education> _education = [
    Education()
  ];
  List<Skills> _skills = [
    Skills(skillNm: 'Programming Language',skillData: 'Nodejs , Python ,PhP'),
    Skills(skillNm: 'Framework/Library',skillData: 'ExpressJS, Codeigniter, Yii, Laravel, Cake, Magento'),
    // Skills(skillNm: 'Operating System',skillData: 'Windows'),
    // Skills(skillNm: 'Source control',skillData: 'Git '),
    // Skills(skillNm: 'Project Management tool',skillData: 'Jira, AzureDevOps '),
    // Skills(skillNm: 'Others',skillData: 'HTML/CSS, Javascript, jquery '),
    // Skills(skillNm: 'Databases',skillData: 'MySql, MSSQL, MongoDB  '),
  ];
  Map<String, TextEditingController> _controllerMap = {};
  List<String> dataskill =[];
  // TextEditingController _schoolController =TextEditingController();
  // TextEditingController _majorsController =TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double marginleft = MediaQuery.of(context).size.width * 0.15;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            children: [
              HorirontalLine('EDUCATION'),
              SizedBox(
                height: 20,
              ),
              _buildEducation(context),
              SizedBox(
                height: 50,
              ),
              HorirontalLine('Skill'),
              SizedBox(
                height: 20,
              ),
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

  Widget _buildEducation(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: _education.length,
            itemBuilder: (context, index) {
              final schoolItem = _education[index].schoolNm;
              final majorsItem = _education[index].majorMn;
              final educationItem = _education[index];
              return _buildEducationItem(context, educationItem, index);
            }),
        IconButton(
            onPressed: () {
                setState(() {
                  _education.add(new Education());
                  print(_education.length);
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

  Widget _buildEducationItem(
      BuildContext context, Education education, int index) {
    return Container(
      padding: EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
      margin: EdgeInsets.only(
          bottom: 30, left: MediaQuery.of(context).size.width * 0.15),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  setState(() {
               _education.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.highlight_remove,
                  size: 30.0,
                  color: Colors.red,
                )),
          ),
          SizedBox(height: 15.0,),
          Row(
            children: [
              Expanded(
                  flex: 8,
                  child: FormInputData(
                      _generateController(
                          'school-$index', _education[index].schoolNm),_education[index].schoolNm)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  flex: 8,
                  child: FormInputData(
                      _generateController(
                          'majors-$index', _education[index].majorMn),_education[index].majorMn)),
              SizedBox(
                width: 7,
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Select Year"),
                          content: Container(
                            // Need to use container to add size constraint.
                            width: 300,
                            height: 300,
                            child: YearPicker(
                              firstDate: DateTime(DateTime.now().year - 100, 1),
                              lastDate: DateTime(DateTime.now().year + 100, 1),
                              initialDate: DateTime.now(),
                              selectedDate: DateTime.now(),
                              onChanged: (DateTime dateTime) {
                                _education[index].classYear = dateTime.year.toString();
                                setState(() {
                                  print(education.classYear);
                                  Navigator.pop(context);
                                });
                                // Do something with the dateTime selected.
                                // Remember that you need to use dateTime.year to get the year
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child:Row(
                    children: [
                      Text(_education[index].classYear  ?? DateTime.now().year.toString()),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSkill(BuildContext context)
  {
    return
        Column(children: [
          Column(
            children:_skills.map((e) => _buildSkillsItem(context, e, _skills.indexOf(e))).toList(),
          ),
          IconButton(icon: Icon(Icons.add_circle_outline,color: kmainColor,), onPressed: () {
          setState(() {
            _skills.add(Skills());
          });
          },)
        ],
    );
  }

  Widget _buildSkillsItem(BuildContext context, Skills skill, int index) {
    return Container(

      padding: EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
      margin: EdgeInsets.only(bottom: 30, left: MediaQuery.of(context).size.width * 0.15),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
      child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               IconButton(icon: Icon(Icons.highlight_remove_outlined,color: Colors.red,size: 30,), onPressed: () {
                 setState(() {
                   _skills.removeAt(index);
                 });
               },)
             ],
           ),
           SizedBox(height: 15,),
           FormInputData( _generateController('sikll-${index}',_skills[index].skillNm),_skills[index].skillNm),
           SizedBox(height: 10,),
           FormInputData( _generateController('siklldata-${index}',_skills[index].skillData),_skills[index].skillData),
         ],
      ),
    );
  }
}
