import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

class SectionFour extends StatefulWidget {
  final CVModel cvModel;
  final PageController pageController;

  SectionFour({this.cvModel, this.pageController});

  @override
  _SectionFourState createState() => _SectionFourState();
}

class _SectionFourState extends State<SectionFour> {
  Map<String, TextEditingController> _controllerHighlightProject = {};
  List<HighLightProject> _highLightProjectList = [];
  HighLightProject highLightProject;
  List<String> _technologiesList = [
    'Node JS',
    'MongoDB',
    'React JS',
    'Redis',
    'Elasticsearch',
    'Nest JS'
  ];

  List<String> _languages = ['English', 'Japanese', 'Vietnamese'];
  List<String> _levels = ['Intermediate', 'Upper-Intermediate', 'Excellent'];

  @override
  void initState() {
    if (widget.cvModel.highLightProjectList != null &&
        widget.cvModel.highLightProjectList.isNotEmpty) {
      _highLightProjectList = widget.cvModel.highLightProjectList;
    } else {
      _highLightProjectList = [
        HighLightProject(
            position: '',
            projectDescription: '',
            responsibility: [],
            teamSize: '',
            technologies: [],
            projectNm: '')
      ];
      widget.cvModel.highLightProjectList = [
        HighLightProject(
            position: '',
            projectDescription: '',
            responsibility: [],
            teamSize: '',
            technologies: [],
            projectNm: '')
      ];
    }
    if(widget.cvModel.languages != null && widget.cvModel.languages.isNotEmpty){

    }else{
      widget.cvModel.languages=[Language(level: '',languageNm: '',positionLevel: 0,positionLanguage: 0)];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: w * 0.05),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Column(
              children: [
                HorizontalLine('Language'),
                SizedBox(
                  height: 10,
                ),
                _buildLanguage(context),
                SizedBox(
                  height: 16,
                ),
                HorizontalLine('Project Highlight'),
                SizedBox(
                  height: 10,
                ),
                _buildHighLightProject(context),
              ],
            )),
      ),
    );
  }

  Widget _buildHighLightProject(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: widget.cvModel.highLightProjectList
                .map((e) => _buildHighLightProjectItem(
                    context, e, widget.cvModel.highLightProjectList.indexOf(e)))
                .toList(),
          ),
          AddButton(
            isButtonText: true,
            textButton: 'ADD PROJECT',
            onPressed: () => setState(() {
              widget.cvModel.highLightProjectList.add(HighLightProject(
                  technologies: [],
                  teamSize: '',
                  responsibility: [],
                  projectDescription: '',
                  position: ''));
            }),
          )
        ],
      ),
    );
  }

  Widget _buildHighLightProjectItem(
      BuildContext context, HighLightProject project, int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 40,
      ),
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 18.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: colorBorderBox),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.cvModel.highLightProjectList.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Colors.red,
                    size: 30,
                  )),
            ],
          ),
          TextFieldCommon(
            label: 'Project name',
            controller: _generateController(
              'projectName-$index',
              _highLightProjectList[index].projectNm,
            ),
            onChanged: (val) {
              widget.cvModel.highLightProjectList[index].projectNm = val;
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFieldCommon(
            maxLines: 3,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            label: 'Project Description',
            controller: _generateController(
              'description-$index',
              _highLightProjectList[index].projectDescription,
            ),
            onChanged: (val) {
              widget.cvModel.highLightProjectList[index].projectDescription =
                  val;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldCommon(
                  label: 'Position',
                  controller: _generateController(
                    'position-$index',
                    _highLightProjectList[index].position,
                  ),
                  onChanged: (val) {
                    widget.cvModel.highLightProjectList[index].position = val;
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextFieldCommon(
                  label: 'Team size',
                  controller: _generateController(
                    'teamSize-$index',
                    _highLightProjectList[index].teamSize,
                  ),
                  onChanged: (val) {
                    widget.cvModel.highLightProjectList[index].teamSize = val;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.work,
                color: Color(0xff434b65),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                'Responsibility ',
                style: CommonStyle.size20W400black(context),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Column(
                children: project.responsibility
                    .map((responsibility) => _buildResponsibility(
                        context,
                        responsibility,
                        project.responsibility,
                        project.responsibility.indexOf(responsibility)))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddButton(
                    isButtonText: true,
                    textButton: 'ADD RESPONSIBILITY',
                    onPressed: () =>
                        setState(() => project.responsibility.add('')),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _autoComplete(context, index)
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Wrap(
                children: widget
                    .cvModel.highLightProjectList[index].technologies
                    .map((technologies) => _buildTechnologiesItem(
                        context,
                        widget.cvModel.highLightProjectList[index].technologies,
                        widget.cvModel.highLightProjectList[index].technologies
                            .indexOf(technologies)))
                    .toList(),
              ),
            ],
          )
        ],
      ),
    );
  }

  // AutocompleteTextField UI
  Widget _autoComplete(BuildContext context, int index) {
    return Autocomplete<String>(
      fieldViewBuilder: (context, controller, focus, func) {
        controller.text = '';
        return TextFieldCommon(
          controller: controller,
          focusNode: focus,
          label: 'Technology',
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return Iterable<String>.empty();
        } else {
          return _technologiesList.where((element) => element
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()));
        }
      },
      onSelected: (String selection) {
        setState(() {
          widget.cvModel.highLightProjectList[index].technologies
              .add(selection);
        });
      },
    );
  }

  Widget _buildResponsibility(BuildContext context, String value,
      List<String> responsibilities, int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: TextFieldCommon(
              controller: _generateController('responsibility-$index', value),
              onChanged: (val) {
                setState(() {
                  responsibilities[index] = val;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  responsibilities.removeAt(index);
                });
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  Widget _buildTechnologiesItem(
      BuildContext context, List<String> listTechnologies, int index) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: Chip(
          backgroundColor: kmainColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(w * 0.005))),
          labelStyle:
              CommonStyle.inputStyle(context).copyWith(color: Colors.white),
          deleteIcon: Container(
            height: 20.0,
            width: 20.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: Color(0xff222222),
            ),
          ),
          onDeleted: () {
            setState(() {
              listTechnologies.removeAt(index);
            });
          },
          labelPadding: EdgeInsets.symmetric(horizontal: 4),
          deleteIconColor: Colors.white,
          label: Text(listTechnologies[index].toString())),
    );
  }

  Widget _buildLanguage(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: 40, left: MediaQuery.of(context).size.width * 0.15),
      padding:
          EdgeInsets.only(left: 16.0, right: 16.0, bottom: 18.0, top: 16.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: colorBorderBox),
      ),
      child: Column(children: [
        Column(
          children: widget.cvModel.languages
              .map((e) => _buildLanguageItem(
                  context, e, widget.cvModel.languages.indexOf(e)))
              .toList(),
        ),
        AddButton(
          isButtonText: true,
          textButton: 'ADD LANGUAGE',
          onPressed: () => setState(() => widget.cvModel.languages
              .add(Language(level: _levels[0], languageNm: _languages[0]))),
        )
      ]),
    );
  }

  Widget _buildLanguageItem(
      BuildContext context, Language language, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: ControlTypeDropDown(
                menuList: _languages,
                onChange: (value) {
                  setState(() {
                    print(value);
                    language.positionLanguage = value;
                    language.languageNm = _languages[value];
                  });
                },
                initPosition: language.positionLanguage,
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 3,
              child: ControlTypeDropDown(
                menuList: _levels,
                onChange: (value) {
                  setState(() {
                    language.positionLevel = value;
                    language.level = _levels[value];
                  });
                  print(value);
                },
                initPosition: language.positionLevel,
              )),
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  widget.cvModel.languages.removeAt(index);
                });
              },
              icon: Icon(
                Icons.close_rounded,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  TextEditingController _generateController(String id, String value) {
    var key = id;
    TextEditingController controller = _controllerHighlightProject[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    controller.text = value;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerHighlightProject[key] = controller;
    return controller;
  }
}
