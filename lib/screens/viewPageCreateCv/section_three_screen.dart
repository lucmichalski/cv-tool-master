import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/option_view_builder.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

import '../../helper.dart';

class SectionThree extends StatefulWidget {
  final CVModel cvModel;
  final DateTime initialDate;
  final PageController pageController;
  final MasterData masterData;

  SectionThree({this.initialDate, this.cvModel, this.pageController, this.masterData});

  @override
  _SectionThreeState createState() => _SectionThreeState();
}

class _SectionThreeState extends State<SectionThree> {
  DateTime selectDate;
  // List<Professional> widget.cvModel.professionalList = [];
  Map<String, TextEditingController> _controllerProfessional = {};
  List<String> _draftResponsibilities = [];
  List<String> _professionalResponsibilities = [];
  // List role
  List<String> _roleNmList = [];
  List<CompanyMaster> _companyMaster = [];

  @override
  void initState() {
    if (widget.masterData != null && widget.masterData.companyMaster.isNotEmpty &&  widget.masterData.companyMaster.isNotEmpty != null) {
      _companyMaster = widget.masterData.companyMaster;
      widget.masterData.companyMaster.forEach((element) {
        _roleNmList.add(element.role);
      });
    }
    if (widget.cvModel.professionalList == null ||
        widget.cvModel.professionalList.isEmpty) {
      widget.cvModel.professionalList = [
        ProfessionalList(
            startDate: monthYear(DateTime.now()),
            responsibilities: [],
            locationNm: '',
            endDate: monthYear(DateTime.now()),
            companyNm: '',
            roleNm: '')
      ];
    }
    selectDate = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          child: Column(
            children: [
              SizedBox(height: 50,),
              HorizontalLine('Professional Experience'),
              SizedBox(height: 20,),
              _buildProfessional(context),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (widget.pageController.hasClients) {
                            widget.pageController.animateToPage(
                              1,
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
                              3,
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOut,
                            );
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessional(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
      child: Column(
        children: [
          Column(
            children: widget.cvModel.professionalList
                .map((e) => _buildProfessionalItem(
                    context, e, widget.cvModel.professionalList.indexOf(e)))
                .toList(),
          ),
          AddButton(
            isButtonText: true,
            textButton: 'ADD EXPERIENCE',
            onPressed: () => setState(() {
              widget.cvModel.professionalList.add(ProfessionalList(
                  startDate: monthYear(DateTime.now()),
                  responsibilities: [],
                  locationNm: '',
                  endDate: monthYear(DateTime.now()),
                  companyNm: '',
                  roleNm: ''));
            }),
          )
        ],
      ),
    );
  }

  Widget _buildProfessionalItem(
      BuildContext context, ProfessionalList professional, int index) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: colorBorderBox)),
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    final jsonBody = json.encode(professional);
                    var professionalItem = ProfessionalList.fromJson(json.decode(jsonBody));
                    widget.cvModel.professionalList.add(professionalItem);
                  });
                }, icon: Icon(Icons.copy)),
                IconButton(
                  icon: Icon(Icons.highlight_remove_sharp, color: Colors.red),
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      widget.cvModel.professionalList.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: TextFieldCommon(
                  controller: _generateControllerProfessional('company-$index',
                      widget.cvModel.professionalList[index].companyNm),
                  onChanged: (val) {
                    professional.companyNm = val;
                  },
                  label: 'Company Name',
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: TextFieldCommon(
                  onChanged: (value) {
                    professional.locationNm = value;
                  },
                  controller: _generateControllerProfessional('location-$index',
                  widget.cvModel.professionalList[index].locationNm),
                  label: 'Location',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Start Date ',
                    style: CommonStyle.size16W400hintTitle(context),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      showMonthPicker(
                              context: context,
                              firstDate: DateTime(
                                DateTime.now().year - 1,
                              ),
                              lastDate: DateTime(
                                DateTime.now().year + 1,
                              ),
                              initialDate: selectDate ?? widget.initialDate)
                          .then((date) => setState(() {
                                selectDate = date;
                                professional.startDate = monthYear(selectDate);
                                print(professional.startDate);
                              }));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(w * 0.001)),
                          border:
                              Border.all(color: Color(0xffd4dcec), width: 1)),
                      child: Row(
                        children: [
                          Text(
                            '${professional.startDate ?? monthYear(DateTime.now())}' ?? kEmpty,
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
                    ),
                  )
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'End Date ',
                      style: CommonStyle.size16W400hintTitle(context),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        showMonthPicker(
                                context: context,
                                firstDate: DateTime(
                                  DateTime.now().year - 1,
                                ),
                                lastDate: DateTime(
                                  DateTime.now().year + 1,
                                ),
                                initialDate: selectDate ?? widget.initialDate)
                            .then((date) => setState(() {
                                  selectDate = date;
                                  professional.endDate = monthYear(selectDate);
                                  print(professional.startDate);
                                }));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(w * 0.001)),
                            border:
                                Border.all(color: Color(0xffd4dcec), width: 1)),
                        child: Row(
                          children: [
                            Text(
                              '${professional.endDate ?? monthYear(DateTime.now())}'?? kEmpty,
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _buildAutoComplete(context, index),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: List.generate(professional.responsibilities.length, (idx) => _buildResponsibilityItem(
            context,
                professional.responsibilities[idx],
            professional.responsibilities,
            '$index',
                idx))
            // professional.responsibilities
            //     .map((responsibility) => _buildResponsibilityItem(
            //         context,
            //         responsibility,
            //         professional.responsibilities,
            //         '$index',
            //         professional.responsibilities.indexOf(responsibility)))
            //     .toList(),
          ),
          SizedBox(
            height: 16,
          ),
          AddButton(
            isButtonText: true,
            textButton: 'ADD RESPONSIBILITY',
            onPressed: () => setState(() {
              professional.responsibilities.add('');
            }),
          )
        ],
      ),
    );
  }

  Widget _buildAutoComplete(BuildContext context, int index) {
    return LayoutBuilder(
      builder: (context,constrains)=>
       Autocomplete<String>(
        fieldViewBuilder: (context, controller, focus, func) {
          controller.text = widget.cvModel.professionalList[index].roleNm;
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
          return TextFieldCommon(
            maxLines: 1,
            label: 'Role',
            controller: controller,
            onChanged: (value) {
                widget.cvModel.professionalList[index].roleNm = value;
            },
            focusNode: focus,
          );
        },
        optionsViewBuilder: (context, onSelected, options) => OptionViewBuilder(
          onSelected: onSelected,
          constraint: constrains,
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
            widget.cvModel.professionalList[index].roleNm = selection;
            var responsibility = _companyMaster.firstWhere((element) => element.role == selection, orElse: () => null);
            if (responsibility != null) {
              widget.cvModel.professionalList[index].responsibilities.addAll(responsibility.responsibilities);
            }
          });
        },
      ),
    );
  }

  Widget _buildResponsibilityItem(BuildContext context, String value,
      List<String> responsibilities, String idProfessional, int index) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              controller: _generateControllerProfessional(
                  '$idProfessional-responsibilities-$index', value),
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
            icon: Icon(Icons.close_rounded),
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  TextEditingController _generateControllerProfessional(
      String id, String value) {
    var key = id;
    TextEditingController controller = _controllerProfessional[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    TextSelection previousSelection = controller.selection;
    controller.text = value;
    controller.selection = previousSelection;
    _controllerProfessional[key] = controller;
    return controller;
  }
}
