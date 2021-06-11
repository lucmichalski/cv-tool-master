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
  SectionThree({this.initialDate, this.cvModel});
  @override
  _SectionThreeState createState() => _SectionThreeState();
}

class _SectionThreeState extends State<SectionThree> {
  DateTime selectDate;
  List<Professional> _listProfessional = [];
  Map<String, TextEditingController> _controllerProfessional = {};

  @override
  void initState() {
    _listProfessional = widget.cvModel.professionalList;
    _listProfessional.add(Professional(
        startDate: '',
        responsibilities: [],
        locationNm: '',
        endDate: '',
        companyNm: '',
        roleNm: ''));
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
              HorirontalLine('Professional Experience'),
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
          children: _listProfessional
              .map((e) => _buildProfessionalItem(
                  context, e, _listProfessional.indexOf(e)))
              .toList(),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _listProfessional.add(Professional(
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
                    _listProfessional.removeAt(index);
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
                      'company-$index', _listProfessional[index].companyNm),
                  onChange: (val) {
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
                  child: TextFormField(
                    onChanged: (value) {
                      professional.locationNm = value;
                    },
                    controller: _generateControllerProfessional(
                        'location-$index', _listProfessional[index].locationNm),
                    decoration: CommonStyle.InputFormDecoration(context),
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
            child: TextFormField(
              decoration: CommonStyle.InputFormDecoration(context),
              controller: _generateControllerProfessional(
                  'role-$index', _listProfessional[index].roleNm),
              onChanged: (value) {
                _listProfessional[index].roleNm = value;
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

  Widget _buildResponsibilityItem(BuildContext context, String value,
      List<String> responsibilities, int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 35.0,
            child: TextFormField(
              controller: _generateControllerProfessional(
                  'responsibilities-$index', value),
              decoration: CommonStyle.InputFormDecoration(context),
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
