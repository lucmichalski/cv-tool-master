import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/DatePickers.dart';
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
    if (widget.cvModel.professionalList == null ||
        widget.cvModel.professionalList.isEmpty) {
      widget.cvModel.professionalList = [
        Professional(
            startDate: '',
            responsibilities: [],
            locationNm: '',
            endDate: '',
            companyNm: '',
            roleNm: '')
      ];
    }
    // TODO: implement initState
    selectDate = widget.initialDate; // loi moi ma anh

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 150),
          child: Column(
            children: [
              HorizontalLine('Professional Experience'),
              _buildProfessional(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessional(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.cvModel.professionalList
              .map((e) => _buildProfessionalItem(
                  context, e, widget.cvModel.professionalList.indexOf(e)))
              .toList(),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                widget.cvModel.professionalList.add(Professional(
                    startDate: '',
                    responsibilities: [],
                    locationNm: '',
                    endDate: '',
                    companyNm: '',
                    roleNm: ''));
              });
            },
            icon: Icon(
              Icons.add,
              size: 40,
              color: kmainColor,
            )),
      ],
    );
  }

  Widget _buildProfessionalItem(
      BuildContext context, Professional professional, int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1.0, color: Colors.black)),
      margin: EdgeInsets.only(
          bottom: 40, left: MediaQuery.of(context).size.width * 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.highlight_remove_sharp,
                    color: Colors.red, size: 50),
                onPressed: () {
                  setState(() {
                    widget.cvModel.professionalList.removeAt(index);
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: TextFieldCommon(
                  controller: _generateControllerProfessional(
                      'company-$index', widget.cvModel.professionalList[index].companyNm),
                  onChanged: (val) {
                    professional.companyNm = val;
                  },
                  label: 'Company Name',
                ),
              ),
              SizedBox(
                width: 100,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 35,
                  alignment: Alignment.center,
                  child: TextFieldCommon(
                    onChanged: (value) {
                      professional.locationNm = value;
                    },
                    controller: _generateControllerProfessional(
                        'location-$index', widget.cvModel.professionalList[index].locationNm),
                    label: 'Location',
                  ),
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
              Container(
                child: Row(
                  children: [
                    Text(
                      'Start date:',
                      style: CommonStyle.size20W400black(context),
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
                                  professional.startDate = hhmm(selectDate);
                                  print(professional.startDate);
                                }));
                      },
                      child: Row(
                        children: [
                          Text(
                            '${professional.startDate ?? '${hhmm(DateTime.now())}'}',
                            style: CommonStyle.size20W400black(context),
                          ),
                          Icon(Icons.arrow_drop_down_sharp)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'End date:',
                      style: CommonStyle.size20W400black(context),
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
                                  professional.endDate = hhmm(selectDate);
                                  print(professional.startDate);
                                }));
                      },
                      child: Row(
                        children: [
                          Text(
                            '${professional.endDate ?? '${hhmm(DateTime.now())}'}',
                            style: CommonStyle.size20W400black(context),
                          ),
                          Icon(Icons.arrow_drop_down_sharp)
                        ],
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
          Container(
            height: 35.0,
            alignment: Alignment.center,
            child: TextFieldCommon(
              label: 'Role',
              controller: _generateControllerProfessional(
                  'role-$index', widget.cvModel.professionalList[index].roleNm),
              onChanged: (value) {
                widget.cvModel.professionalList[index].roleNm = value;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Participate in various software development phase such as:',
            textAlign: TextAlign.start,
            style: CommonStyle.size20W400black(context),
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
                    professional.responsibilities.indexOf(responsibility)))
                .toList(),
          ),
          SizedBox(
            height: 16,
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  professional.responsibilities.add('');
                });
              },
              icon: Icon(
                Icons.add_circle_outline_rounded,
                size: 30,
              )),
        ],
      ),
    );
  }

  Widget _buildResponsibilityItem(BuildContext context, String value, List<String> responsibilities, int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 35.0,
            child: TextFieldCommon(
              controller: _generateControllerProfessional(
                  'responsibilities-$index', value),
              onChanged: (val) {
                setState(() {
                  responsibilities[index] = val;
                });
              },
            ),
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
    );
  }

  TextEditingController _generateControllerProfessional(String id, String value) {
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
