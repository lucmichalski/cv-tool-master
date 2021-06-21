import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';

import '../../helper.dart';

class SectionThree extends StatefulWidget {
  final CVModel cvModel;
  final DateTime initialDate;
  final PageController pageController;

  SectionThree({this.initialDate, this.cvModel, this.pageController});

  @override
  _SectionThreeState createState() => _SectionThreeState();
}

class _SectionThreeState extends State<SectionThree> {
  DateTime selectDate;

  // List<Professional> widget.cvModel.professionalList = [];
  Map<String, TextEditingController> _controllerProfessional = {};

  @override
  void initState() {
    // Create mode
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
          margin: EdgeInsets.symmetric(horizontal: w * 0.2),
          child: Column(
            children: [
              SizedBox(height: 50,),
              HorizontalLine('Professional Experience'),
              _buildProfessional(context),
              SizedBox(
                height: 10,
              ),
              Row(
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
                      icon: Icon(
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
                            '${professional.startDate ?? monthYear(DateTime.now())}',
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
                              '${professional.endDate ?? monthYear(DateTime.now())}',
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
          TextFieldCommon(
            label: 'Role',
            controller: _generateControllerProfessional(
                'role-$index', widget.cvModel.professionalList[index].roleNm),
            onChanged: (value) {
              widget.cvModel.professionalList[index].roleNm = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.label, color: Color(0xff434b65)),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  'Participate in various software development phase such as:',
                  textAlign: TextAlign.start,
                  style: CommonStyle.size20W400black(context),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: professional.responsibilities
                .map((responsibility) => _buildResponsibilityItem(
                    context,
                    responsibility,
                    professional.responsibilities,
                    '$index',
                    professional.responsibilities.indexOf(responsibility)))
                .toList(),
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
    controller.text = value;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    _controllerProfessional[key] = controller;
    return controller;
  }
}
