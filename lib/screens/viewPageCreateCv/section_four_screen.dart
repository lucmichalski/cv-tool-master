import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/expanded_section.dart';
import 'package:flutter_cv_maker/common/option_view_builder.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

class SectionFour extends StatefulWidget {
  final CVModel cvModel;
  final PageController pageController;
  final MasterData masterData;

  SectionFour({this.cvModel, this.pageController, this.masterData});

  @override
  _SectionFourState createState() => _SectionFourState();
}

class _SectionFourState extends State<SectionFour> {
  Map<String, TextEditingController> _controllerHighlightProject = {};
  List<HighLightProjectList> _highLightProjectList = [];
  HighLightProjectList highLightProject;
  List<String> _technologiesList = [];

  List<String> _languages = ['English', 'Japanese', 'Vietnamese'];
  List<String> _levels = ['Intermediate', 'Upper-Intermediate', 'Excellent'];
  List<String> _roleNmList = [];

  @override
  void initState() {
    if (widget.masterData != null &&
        widget.masterData.companyMaster.isNotEmpty &&
        widget.masterData.companyMaster.isNotEmpty != null) {
      widget.masterData.projectMaster.forEach((element) {
        _roleNmList.add(element.role);
      });
    }
    if (widget.cvModel.highLightProjectList != null &&
        widget.cvModel.highLightProjectList.isNotEmpty) {
      _highLightProjectList = widget.cvModel.highLightProjectList;
    } else {
      _highLightProjectList = [
        HighLightProjectList(
            position: '',
            projectDescription: '',
            responsibility: [],
            teamSize: '',
            technologies: [],
            projectNm: '',
            uiuxdesign: '',
            projectmanagementtool: '',
            documentcontrol: '',
            communicationused: '')
      ];
      widget.cvModel.highLightProjectList = [
        HighLightProjectList(
            position: '',
            projectDescription: '',
            responsibility: [],
            teamSize: '',
            technologies: [],
            projectNm: '',
            uiuxdesign: '',
            projectmanagementtool: '',
            documentcontrol: '',
            communicationused: '')
      ];
    }
    // Get master data technology
    if (widget.masterData != null &&
        widget.masterData.technicalUsed != null &&
        widget.masterData.technicalUsed.isNotEmpty) {
      widget.masterData.technicalUsed.forEach((technicalUsed) {
        _technologiesList.add(technicalUsed);
      });
      _technologiesList = widget.masterData.technicalUsed ?? [];
    }

    if (widget.cvModel.languages == null || widget.cvModel.languages.isEmpty)
      widget.cvModel.languages = [
        Languages(
            level: '', languageNm: '', positionLevel: 0, positionLanguage: 0)
      ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
        child: Container(
            // margin: EdgeInsets.symmetric(horizontal: w * 0.2),
            child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
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
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        if (widget.pageController.hasClients) {
                          widget.pageController.animateToPage(
                            2,
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
                            4,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut,
                          );
                        }
                      }),
                ],
              ),
            )
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
          ReorderableListView(
            physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              buildDefaultDragHandles: false,
              children: widget.cvModel.highLightProjectList
                  .map((e) => _buildHighLightProjectItem(context, e,
                      widget.cvModel.highLightProjectList.indexOf(e)))
                  .toList(),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item =
                      widget.cvModel.highLightProjectList.removeAt(oldIndex);
                  widget.cvModel.highLightProjectList.insert(newIndex, item);
                });
              }),
          AddButton(
            isButtonText: true,
            textButton: 'ADD PROJECT',
            onPressed: () => setState(() {
              widget.cvModel.highLightProjectList.add(HighLightProjectList(
                  technologies: [],
                  projectNm: '',
                  teamSize: '',
                  responsibility: [],
                  projectDescription: '',
                  position: '',
                  uiuxdesign: '',
                  documentcontrol: '',
                  communicationused: '',
                  projectmanagementtool: '',
                  isExpand: false));
            }),
          )
        ],
      ),
    );
  }

  Widget _buildHighLightProjectItem(
      BuildContext context, HighLightProjectList project, int index) {
    return Container(
      key: ValueKey('$index'),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 18.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: colorBorderBox),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_handle,
                  )),
              Spacer(),
              IconButton(
                  tooltip: project.isExpand ? 'Collapse' : 'Expand',
                  hoverColor: Colors.transparent,
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      print('Tap expand: ${project.isExpand}');
                      project.isExpand = !project.isExpand;
                    });
                  },
                  icon: Icon(Icons.wrap_text)),
              IconButton(
                  tooltip: 'Clone',
                  hoverColor: Colors.transparent,
                  splashRadius: 1,
                  onPressed: () {
                    setState(() {
                      final jsonBody = json.encode(project);
                      var highlightProjectItem =
                          HighLightProjectList.fromJson(json.decode(jsonBody));
                      widget.cvModel.highLightProjectList
                          .add(highlightProjectItem);
                    });
                  },
                  icon: Icon(Icons.copy)),
              IconButton(
                  tooltip: 'Delete',
                  hoverColor: Colors.transparent,
                  splashRadius: 1,
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
          ExpandedSection(
            child: _projectHighlightItemExpand(context, project, index),
            expand: project.isExpand,
          )
        ],
      ),
    );
  }

  Widget _projectHighlightItemExpand(
      BuildContext context, HighLightProjectList project, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextFieldCommon(
                label: 'Communication used',
                controller: _generateController(
                  'Communicationused-$index',
                  _highLightProjectList[index].communicationused,
                ),
                onChanged: (val) {
                  widget.cvModel.highLightProjectList[index].communicationused =
                      val;
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFieldCommon(
                label: 'UI&UX design ',
                controller: _generateController(
                  'UIUXdesign -$index',
                  _highLightProjectList[index].uiuxdesign,
                ),
                onChanged: (val) {
                  widget.cvModel.highLightProjectList[index].uiuxdesign = val;
                },
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
              child: TextFieldCommon(
                label: 'Document Control',
                controller: _generateController(
                  'DocumentControl -$index',
                  _highLightProjectList[index].documentcontrol,
                ),
                onChanged: (val) {
                  widget.cvModel.highLightProjectList[index].documentcontrol =
                      val;
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFieldCommon(
                label: 'Project management tool ',
                controller: _generateController(
                  'Projectmanagementtool -$index',
                  _highLightProjectList[index].projectmanagementtool,
                ),
                onChanged: (val) {
                  widget.cvModel.highLightProjectList[index]
                      .projectmanagementtool = val;
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
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
            widget.cvModel.highLightProjectList[index].projectDescription = val;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(child: _autoCompletePosition(context, index)),
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
              style: CommonStyle.size16W400hintTitle(context),
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
                      '$index',
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
            _autoCompleteTechnology(context, index)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Wrap(
              children: widget.cvModel.highLightProjectList[index].technologies
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
    );
  }

  Widget _autoCompletePosition(BuildContext context, int index) {
    return LayoutBuilder(
      builder: (context,constraint)=>
    Autocomplete<String>(
        fieldViewBuilder: (context, controller, focus, func) {
          controller.text = widget.cvModel.highLightProjectList[index].position;
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
          return TextFieldCommon(
            maxLines: 1,
            label: 'Position',
            controller: controller,
            onChanged: (value) {
              widget.cvModel.highLightProjectList[index].position = value;
            },
            focusNode: focus,
          );
        },
      optionsViewBuilder: (context, onSelected, options) => OptionViewBuilder(
        onSelected: onSelected,
        constraint: constraint,
        options: options,
      ),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return Iterable<String>.empty();
          } else {
            return _roleNmList.where((element) => element
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          }
        },
        onSelected: (String selection) {
          setState(() {
            widget.cvModel.highLightProjectList[index].position = selection;
            var responsibility = widget.masterData.projectMaster.firstWhere(
                (element) => element.role == selection,
                orElse: () => null);
            if (responsibility != null) {
              widget.cvModel.highLightProjectList[index].responsibility
                  .addAll(responsibility.responsibilities);
            }
          });
        },
      ),
    );
  }

  // AutocompleteTextField UI
  Widget _autoCompleteTechnology(BuildContext context, int index) {
    return LayoutBuilder(
      builder: (context,constraint)=> Autocomplete<String>(
        fieldViewBuilder: (context, controller, focus, func) {
          controller.text = '';
          return TextFieldCommon(
            maxLines: 1,
            textInputAction: TextInputAction.go,
            onFieldSubmitted: (val) {
              setState(() {
                controller.text = '';
                widget.cvModel.highLightProjectList[index].technologies.add(val);
              });
            },
            controller: controller,
            focusNode: focus,
            label: 'Technology',
          );
        },
        optionsViewBuilder: (context, onSelected, options) => OptionViewBuilder(
          onSelected: onSelected,
          constraint: constraint,
          options: options,
        ),
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
      ),
    );
  }

  Widget _buildResponsibility(BuildContext context, String value,
      List<String> responsibilities, String idResponsibility, int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: TextFieldCommon(
              controller: _generateController(
                  'responsibility-$index-$idResponsibility', value),
              onChanged: (val) {
                setState(() {
                  responsibilities[index] = val;
                });
              },
            ),
          ),
          IconButton(
              splashRadius: 20,
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
          label: Text(listTechnologies[index].toString() ?? kEmpty)),
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
              .add(Languages(level: _levels[0], languageNm: _languages[0]))),
        )
      ]),
    );
  }

  Widget _buildLanguageItem(
      BuildContext context, Languages language, int index) {
    if (language.languageNm == null || language.languageNm.isEmpty)
      language.languageNm = _languages[0];
    if (language.level == null || language.level.isEmpty)
      language.level = _levels[0];
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
    TextSelection previousSelection = controller.selection;
    controller.text = value;
    controller.selection = previousSelection;
    _controllerHighlightProject[key] = controller;
    return controller;
  }
}
