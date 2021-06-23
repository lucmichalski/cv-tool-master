import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

class SecondScreen extends StatefulWidget {
  final CVModel cvModel;
  final PageController pageController;
  final MasterData masterData;

  SecondScreen({this.pageController, this.cvModel, this.masterData});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String year;
  Map<String, TextEditingController> _controllerMap = {};
  Map<String, TextEditingController> _controllerMapSkill = {};
  Map<String, TextEditingController> _controllerMapCertificate = {};

  // Will remove when exist master data
  List<Skills> _skills = [];

  // Selected position
  int _skillSelected = 0;

  // Skill name list
  List<String> _skillNmList = [];

  @override
  void initState() {
    if (widget.masterData != null &&
        widget.masterData.skills != null &&
        widget.masterData.skills.isNotEmpty) {
      widget.masterData.skills.forEach((skill) {
        _skills.add(Skills(skillNm: skill, skillData: '', isSelected: false));
      });
      _skillNmList = widget.masterData.skills ?? [];
    }
    if(widget.cvModel.educationList == null || widget.cvModel.educationList.isEmpty) {
      widget.cvModel.educationList.add(EducationList(majorNm: '',schoolNm: '',classYear: '2021'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: w * 0.05),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: w * 0.2),
          child: Column(
            children: [
              SizedBox(height: 50,),
              HorizontalLine('EDUCATION'),
              SizedBox(
                height: 10,
              ),
              _buildEducation(context),
              SizedBox(
                height: 30,
              ),
              HorizontalLine('SKILLS'),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 30),
                child: _buildSkill(context),
              ),
              HorizontalLine('CERTIFICATE'),
              SizedBox(
                height: 10.0,
              ),
              _buildCertificate(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        if (widget.pageController.hasClients) {
                          widget.pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        'PREVIOUS',
                        style: CommonStyle.white700Size22(context)
                            .copyWith(color: Colors.grey),
                      )),
                  ButtonCommon(
                      buttonText: 'NEXT',
                      suffixIcon: Icon(
                        Icons.arrow_right_alt_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      onClick: () {
                        if (widget.pageController.hasClients) {
                          widget.pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut,
                          );
                        }
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Generating controller for textFormField
  TextEditingController _generateController(String id, String value) {
    var key = id;
    TextEditingController controller = _controllerMap[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // Set text
    controller.text = value;
    // Set cursor
    controller.selection = TextSelection.collapsed(offset: value.length);
    _controllerMap[key] = controller;
    return controller;
  }

  TextEditingController _generateControllerCertificate(
      String id, String value) {
    var key = id;
    TextEditingController controller = _controllerMapCertificate[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    // // Set text
    controller.text = value;
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
    controller.text = value;
    // Set cursor
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerMapSkill[key] = controller;
    return controller;
  }

  Widget _buildEducation(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: w * 0.15),
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.cvModel.educationList.length,
              itemBuilder: (context, index) {
                final educationItem = widget.cvModel.educationList[index];
                return _buildEducationItem(context, educationItem, index);
              }),
          AddButton(
            isButtonText: true,
            textButton: 'ADD EDUCATION',
            onPressed: () => setState(() {
              widget.cvModel.educationList
                  .add(EducationList(classYear: '', schoolNm: '', majorNm: ''));
            }),
          )
        ],
      ),
    );
  }

  // Create education item
  Widget _buildEducationItem(
      BuildContext context, EducationList education, int index) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: colorBorderBox)),
      margin: EdgeInsets.only(bottom: 8),
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
                child: TextFieldCommon(
                    controller: _generateController('school-$index',
                        widget.cvModel.educationList[index].schoolNm),
                    onChanged: (val) {
                      widget.cvModel.educationList[index].schoolNm = val;
                    },
                    label: 'School Name'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldCommon(
                    controller: _generateController('majors-$index',
                        widget.cvModel.educationList[index].majorNm),
                    onChanged: (val) {
                      widget.cvModel.educationList[index].majorNm = val;
                    },
                    label: 'Major'),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(w * 0.001)),
                        border: Border.all(color: Color(0xffd4dcec), width: 1)),
                    child: Row(
                      children: [
                        Text(
                          widget.cvModel.educationList[index].classYear ??
                              DateTime.now().year.toString(),
                          style: CommonStyle.inputStyle(context),
                        ),
                        Container(
                          height: 20,
                          margin: EdgeInsets.only(right: 4, left: 16),
                          child: VerticalDivider(
                            color: Color(0xffdfe5f0),
                            width: 2,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            color: Color(0xff858c98)),
                      ],
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  // Create skill layout
  Widget _buildSkill(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    if (widget.cvModel.skills != null) {
      widget.cvModel.skills.forEach((element1) {
        var a = _skills.firstWhere(
            (element2) => element2.skillNm == element1.skillNm,
            orElse: () => null);
        if (a != null) {
          a.isSelected = true;
        }
      });
    }
    return Padding(
      padding: EdgeInsets.only(left: w * 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: SkillDropDown(
                    menuList: _skills,
                    initPosition: _skillSelected,
                    onChange: (value) =>
                        setState(() => _skillSelected = value)),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ButtonCommon(
                    buttonText: 'Generate',
                    onClick: () async {
                      setState(() {
                        if (!_skills[_skillSelected].isSelected) {
                          _skills[_skillSelected].isSelected = true;
                        }
                        widget.cvModel.skills.add(Skills(
                            skillNm: _skillNmList[_skillSelected],
                            skillData: ''));
                      });
                    }),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ButtonCommon(
                    buttonText: 'Generate All',
                    onClick: () async {
                      setState(() {
                        _skills.forEach((skill) {
                          skill.isSelected = true;
                          widget.cvModel.skills.add(
                              Skills(skillNm: skill.skillNm, skillData: ''));
                        });
                      });
                    }),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Column(
            children: widget.cvModel.skills
                .map((e) => _buildSkillsItem(
                    context, e, widget.cvModel.skills.indexOf(e)))
                .toList(),
          ),
          AddButton(
            isButtonText: true,
            textButton: 'ADD SKILL',
            onPressed: () => setState(() {
              widget.cvModel.skills.add(Skills());
            }),
          )
        ],
      ),
    );
  }

  Widget _buildSkillsItem(BuildContext context, Skills skill, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: colorBorderBox)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.highlight_remove_outlined,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    var _skill = _skills.firstWhere(
                        (element) => element.skillNm == skill.skillNm,
                        orElse: () => null);
                    if (_skill != null) _skill.isSelected = false;
                    widget.cvModel.skills.removeAt(index);
                  });
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TextFieldCommon(
              controller: _generateControllerSkill(
                  'skill-$index', widget.cvModel.skills[index].skillNm),
              label: 'Skill name',
              onChanged: (val) {
                widget.cvModel.skills[index].skillNm = val;
              },
            ),
          ),
          TextFieldCommon(
            controller: _generateControllerSkill(
                'skilldata-$index', widget.cvModel.skills[index].skillData),
            label: 'Skill data',
            onChanged: (val) {
              widget.cvModel.skills[index].skillData = val;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCertificate(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: w * 0.15, bottom: w * 0.03),
      child: Column(
        children: [
          Column(
            children: widget.cvModel.certificateList
                .map((e) => _buildCertificationItems(
                    context, e, widget.cvModel.certificateList.indexOf(e)))
                .toList(),
          ),
          AddButton(
            isButtonText: true,
            textButton: 'ADD CERTIFICATE',
            onPressed: () => setState(() {
              widget.cvModel.certificateList.add(CertificateList());
            }),
          )
        ],
      ),
    );
  }

  Widget _buildCertificationItems(
      BuildContext context, CertificateList certificate, int index) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              controller: _generateControllerCertificate('certification-$index',
                  widget.cvModel.certificateList[index].certificateNm),
              onChanged: (val) {
                widget.cvModel.certificateList[index].certificateNm = val;
              },
            ),
          ),
          SizedBox(
            width: 16,
          ),
          //:TODO
          TextButton(
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
                            widget.cvModel.certificateList[index]
                                .certificateYear = dateTime.year.toString();
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
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(w * 0.001)),
                    border: Border.all(color: Color(0xffd4dcec), width: 1)),
                child: Row(
                  children: [
                    Text(
                      widget.cvModel.certificateList[index].certificateYear ??
                          DateTime.now().year.toString(),
                      style: CommonStyle.inputStyle(context),
                    ),
                    Container(
                      height: 20,
                      margin: EdgeInsets.only(right: 4, left: 16),
                      child: VerticalDivider(
                        color: Color(0xffdfe5f0),
                        width: 2,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xff858c98)),
                  ],
                ),
              )),
          SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.cvModel.certificateList.removeAt(index);
              });
            },
            icon: Icon(Icons.close_rounded),
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
