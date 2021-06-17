import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/utils/validation.dart';

class SectionOneScreen extends StatefulWidget {
  final CVModel cvModel;
  final Function onSaved;
  final PageController pageController;

  SectionOneScreen({this.cvModel, this.onSaved, this.pageController});

  @override
  _SectionOneScreenState createState() => _SectionOneScreenState();
}

class _SectionOneScreenState extends State<SectionOneScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  Map<String, TextEditingController> _controllerMap = {};

  // List display summary
  List<String> _listSummary = [];
  CVModel _cvModel;
  List<String> _listRoleNm = [];

  // role name selected
  int _roleNmSelected = 0;
  int _levelSelected;
  int _technicalSelected;

  // Gender selected
  var _genderSelected = '';

  List<Role> _roles = [
    Role(
        roleNm: 'BA',
        level: ['BA1', 'BA2', 'BA3'],
        technicals: ['BAa', 'BAb', 'BAc']),
    Role(
        roleNm: 'DEV',
        level: ['Dev4', 'Dev5', 'Dev6'],
        technicals: ['Deva', 'Devb', 'Devc']),
  ];

  List<String> _technicalSumData = [
    '5 years’ experiences in software development specialize in web backend development. ',
    'Good understanding of server-side templating technical, system architectural. ',
    'Many experiences working with API design, DB design. '
  ];

  @override
  void initState() {
    // Get CV Model
    _cvModel = widget.cvModel;
    _roles.forEach((role) {
      _listRoleNm.add(role.roleNm);
    });

    _initializationData();
    super.initState();
  }

  // Fill data when in edit mode
  _initializationData() {
    _fullNameController.text = _cvModel.name ?? kEmpty;
    _emailController.text = _cvModel.email ?? kEmpty;
    _positionController.text = _cvModel.position ?? kEmpty;
    // Get data for Technical Summary
    _listSummary = _cvModel.technicalSummaryList;
  }

  @override
  Widget build(BuildContext context) {
    double sizeWith = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: sizeWith * 0.05),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: sizeWith * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                HorizontalLine('INFORMATION'),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(right: sizeWith / 12),
                  padding: EdgeInsets.only(left: sizeWith / 6),
                  child: Column(
                    children: [
                      TextFieldCommon(
                        controller: _fullNameController,
                        label: 'Full Name',
                        validator: (name) =>
                            Validation().checkValidNameField(context, name),
                      ),
                      // InputTextFormfield('Full Name', _fullNameController,'Please enter your fullname'),
                      _buildGender(context),
                      TextFieldCommon(
                        controller: _emailController,
                        label: 'Email',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldCommon(
                        label: 'Position',
                        controller: _positionController,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                HorizontalLine('TECHNICAL SUMMARY'),
                _buildListSummary(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Create gender layout
  Widget _buildGender(BuildContext context) {
    return Row(
      children: kGenders
          .map((gender) => Expanded(
                child: RadioListTile(
                    value: gender,
                    activeColor: kmainColor,
                    title: Text(
                      '$gender',
                      style: CommonStyle.inputStyle(context),
                    ),
                    groupValue: 'Male',
                    onChanged: (val) {
                      print('Gender: $val');
                      setState(() => _genderSelected = val);
                    }),
              ))
          .toList(),
    );
  }

  Widget _buildListSummary(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          _buildConditionsUI(context, width),
          SizedBox(
            height: width * 0.02,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * 0.1),
            child: ButtonCommon(
                buttonText: 'GET',
                onClick: _roleNmSelected == null ||
                        _technicalSelected == null ||
                        _levelSelected == null
                    ? () => null
                    : () {
                        setState(() {
                          if (_listRoleNm[_roleNmSelected] == 'BA') {
                            _listSummary = _technicalSumData;
                          } else {
                            // _technicalSumData.
                            _listSummary = _technicalSumData.take(2).toList();
                          }
                        });
                      }),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _listSummary.length,
              itemBuilder: (context, index) {
                final item = _listSummary[index];
                return _buildTechnicalSumItem(context, item, index);
              }),
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
            child: AddButton(
              isButtonText: true,
              textButton: 'ADD SUMMARY',
              onPressed: () => setState(() {
                _listSummary.add('');
              }),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonCommon(
                buttonText: 'Next Section',
                onClick: () {
                  //:TODO - Add function next section
                  // CVModel model = CVModel(
                  //   name: _fullNameController.text,
                  //   email: _emailController.text,
                  //   position: _positionController.text,
                  //   gender: kGenders.indexOf(_genderSelected ?? 0),
                  //   status: false,
                  //   role: Role(roleNm: _listRoleNm[_roleNmSelected],
                  //       technicals: [_roles[_roleNmSelected].level[_levelSelected]],
                  //   level: [_roles[_roleNmSelected].technicals[_technicalSelected]]),
                  //   technicalSummaryList: _listSummary
                  // );
                  // var requestBody = json.encoder.convert(model);
                  // print('Request Body: $requestBody');
                  if (_formKey.currentState.validate()) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(_emailController.text);
                    if (_genderSelected.isNotEmpty) {
                      if (emailValid) {
                        if (widget.pageController.hasClients) {
                          widget.pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut,
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Container(
                              alignment: Alignment.center,
                              height: 70,
                              child: Text('Invalid email format')),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Container(
                            alignment: Alignment.center,
                            height: 70,
                            child: Text('Choice your gender')),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  // Technical item
  Widget _buildTechnicalSumItem(
      BuildContext context, String technical, int index) {
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TextFieldCommon(
            controller: _generateController('technical-$index', technical),
            onChanged: (val) {
              _listSummary[index] = val;
            },
          )),
          Container(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  // Remove item
                  _listSummary.removeAt(index);
                });
              },
              splashRadius: 16,
              icon: Icon(
                Icons.close_outlined,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConditionsUI(BuildContext context, double width) => Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Role',
                  style: CommonStyle.size16W400hintTitle(context),
                ),
              ),
              ControlTypeDropDown(
                menuList: _listRoleNm,
                initPosition: _roleNmSelected,
                onChange: (val) {
                  setState(() {
                    _roleNmSelected = val;
                  });
                },
              ),
            ],
          )),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Level',
                  style: CommonStyle.size16W400hintTitle(context),
                ),
              ),
              ControlTypeDropDown(
                menuList: _roles[_roleNmSelected].level,
                initPosition: _levelSelected,
                onChange: (val) {
                  setState(() {
                    _levelSelected = val;
                  });
                },
              ),
            ],
          )),
          SizedBox(
            width: width * 0.03,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Technical',
                  style: CommonStyle.size16W400hintTitle(context),
                ),
              ),
              ControlTypeDropDown(
                  menuList: _roles[_roleNmSelected].technicals,
                  initPosition: _technicalSelected,
                  onChange: (val) {
                    setState(() {
                      _technicalSelected = val;
                    });
                  }),
            ],
          )),
        ],
      );

  // Generate controller by id
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
}
