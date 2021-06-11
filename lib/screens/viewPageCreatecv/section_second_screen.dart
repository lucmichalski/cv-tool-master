import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
class SecondScreen extends StatefulWidget {
  final CVModel cvModel;
  PageController pageController ;
  SecondScreen({this.pageController, this.cvModel});
  @override
  _SecondScreenState createState() => _SecondScreenState();
}
class _SecondScreenState extends State<SecondScreen> {
  String year;
  Map<String, TextEditingController> _controllerMap = {};
  Map<String, TextEditingController> _controllerMapSkill = {};
  Map<String, TextEditingController> _controllerMapCertificate = {};
  @override
  void initState() {
    widget.cvModel.skills= [Skills(skillNm: 'Programming Language', skillData: 'Nodejs , Python ,PhP'),
    Skills(
    skillNm: 'Framework/Library',
    skillData: 'ExpressJS, Codeigniter, Yii, Laravel, Cake, Magento'),
    // Skills(skillNm: 'Operating System',skillData: 'Windows'),
    // Skills(skillNm: 'Source control',skillData: 'Git '),
    // Skills(skillNm: 'Project Management tool',skillData: 'Jira, AzureDevOps '),
    // Skills(skillNm: 'Others',skillData: 'HTML/CSS, Javascript, jquery '),
    // Skills(skillNm: 'Databases',skillData: 'MySql, MSSQL, MongoDB  '),
    ];
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
                height: 10,
              ),
              _buildEducation(context),
              SizedBox(
                height: 30,
              ),
              HorirontalLine('Skill'),
              SizedBox(
                height: 10,
              ),
              _buildSkill(context),
              SizedBox(height: 30.0,),
              HorirontalLine('CERTIFICATE'),
              SizedBox(height: 10.0,),
              _buildCertificate(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonCommon(buttonText: 'Previous Selection', onClick: (){
                    if (widget.pageController.hasClients) {
                      widget.pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                      );
                    }
                  }),
                  ButtonCommon(buttonText: 'Next Section', onClick: (){
                    if (widget.pageController.hasClients) {
                      widget.pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                      );
                    }
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController _generateController(String id, String value) {

    var key = id;
    TextEditingController controller = _controllerMap[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // // Set text
    controller.text = value; /// No se khong gan duoc
    // Set cursor
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerMap[key] = controller;
    return controller;
  }
  TextEditingController _generateControllerCertificate(String id, String value) {

    var key = id;
    TextEditingController controller = _controllerMapCertificate[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // // Set text
    controller.text = value; /// No se khong gan duoc
    // Set cursor
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerMapCertificate[key] = controller;
    return controller;
  }

  TextEditingController _generateControllerSkill(String id, String value) {

    var key = id;
    TextEditingController controller = _controllerMapSkill[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // // Set text
    controller.text = value; /// No se khong gan duoc
    // Set cursor
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerMapSkill[key] = controller;
    return controller;
  }

  Widget _buildEducation(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.cvModel.educationList.length,
            itemBuilder: (context, index) {
              final educationItem = widget.cvModel.educationList[index];
              return _buildEducationItem(context, educationItem, index);
            }),
        IconButton(
            onPressed: () {
              setState(() {
                widget.cvModel.educationList.add(Education());
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
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
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
                    widget.cvModel.educationList.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.highlight_remove,
                  size: 30.0,
                  color: Colors.red,
                )),
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Expanded(
                  flex: 8,
                  child:
                  Container(
                    height: 30,
                    child: TextFormField(
                        controller: _generateController('school-$index', widget.cvModel.educationList[index].schoolNm),
                        onChanged: (val) {
                          widget.cvModel.educationList[index].schoolNm = val;
                        },
                        decoration:CommonStyle.InputFormDecoration(context)
                    ),
                  ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 30,
                  child: TextFormField(
                      controller: _generateController('majors-$index', widget.cvModel.educationList[index].majorMn),
                      onChanged: (val) {
                        widget.cvModel.educationList[index].majorMn = val;
                      },
                      decoration:CommonStyle.InputFormDecoration(context)
                  ),
                ),
              ),
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
                                widget.cvModel.educationList[index].classYear =
                                    dateTime.year.toString();
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
                  child: Row(
                    children: [
                      Text(widget.cvModel.educationList[index].classYear ??
                          DateTime.now().year.toString()),
                      Icon(Icons.arrow_drop_down_sharp)
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }



  Widget _buildSkill(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.cvModel.skills
              .map((e) => _buildSkillsItem(context, e, widget.cvModel.skills.indexOf(e)))
              .toList(),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: kmainColor,
          ),
          onPressed: () {
            setState(() {
              widget.cvModel.skills.add(Skills());
            });
          },
        )
      ],
    );
  }

  Widget _buildSkillsItem(BuildContext context, Skills skill, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(
          bottom: 30, left: MediaQuery.of(context).size.width * 0.15),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.highlight_remove_outlined,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    widget.cvModel.skills.removeAt(index);
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Container(
            height: 30,
            child: TextFormField(
              controller: _generateControllerSkill('skill-$index', widget.cvModel.skills[index].skillNm),
              onChanged: (val) {
                widget.cvModel.skills[index].skillNm = val;
              },
              decoration:CommonStyle.InputFormDecoration(context)
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Container(
            height: 30,
            child: TextFormField(
              controller: _generateControllerSkill('skilldata-$index', widget.cvModel.skills[index].skillData),
              onChanged: (val) {
                widget.cvModel.skills[index].skillData = val;
              },
              decoration: CommonStyle.InputFormDecoration(context)
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCertificate(BuildContext context)
  {
    return Column(
      children: [
        Column(
          children: widget.cvModel.certificateList.map((e) => _buildCertificationItems(context, e, widget.cvModel.certificateList.indexOf(e))).toList(),

        ),
        IconButton(icon :Icon(Icons.add_circle_outline_outlined,color: kmainColor,size: 30),
          onPressed: (){
          setState(() {
            widget.cvModel.certificateList.add(Certificate());
          });
          },),
      ],
    );
  }
  Widget _buildCertificationItems(BuildContext context,Certificate certificate , int index )
  {
    return  Container(
      margin: EdgeInsets.only(
          bottom: 30, left: MediaQuery.of(context).size.width * 0.15),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              height: 30,
              child: TextFormField(
                  controller: _generateControllerCertificate('certification-$index', widget.cvModel.certificateList[index].certificateNm),
                  onChanged: (val) {
                    widget.cvModel.certificateList[index].certificateNm = val;
                  },
                  decoration: CommonStyle.InputFormDecoration(context)
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            flex: 1,
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Select Year"),
                        content: Container(
                          width: 300,
                          height: 300,
                          child: YearPicker(
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime(DateTime.now().year + 100, 1),
                            initialDate: DateTime.now(),
                            selectedDate: DateTime.now(),
                            onChanged: (DateTime dateTime) {
                              widget.cvModel.certificateList[index].certificateYear =
                                  dateTime.year.toString();
                              setState(() {
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
                child: Row(
                  children: [
                    Text(widget.cvModel.certificateList[index].certificateYear ??
                        DateTime.now().year.toString()),
                    Icon(Icons.arrow_drop_down_sharp)
                  ],
                )),
          ),
          Expanded(
            flex: 1,
            child: IconButton(icon :Icon(Icons.highlight_remove,color: Colors.red,size: 30),
            onPressed: (){
             setState(() {
               _controllerMapSkill.removeWhere((key, value) =>
               (key == "skill-${_controllerMapSkill.length - 1}"));
               widget.cvModel.certificateList.removeAt(index);
               _controllerMapCertificate.removeWhere((key , value) => (key =="certification-${_controllerMapCertificate.length-1}"));
             });
            },),
          ),

        ],
      ),
    );
  }
}

