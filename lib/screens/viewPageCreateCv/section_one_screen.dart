import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/option_view_builder.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';

class SectionOneScreen extends StatefulWidget {
  final CVModel cvModel;
  final Function onSaved;
  final PageController pageController;
  final MasterData masterData;
  final String gender;

  SectionOneScreen(
      {this.cvModel, this.onSaved, this.pageController, this.masterData, this.gender});

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
  CVModel _cvModel;
  List<String> _listRoleNm = [];

  // role name selected
  int _roleNmSelected;
  int _levelSelected;
  int _technicalSelected;

  // Gender selected
  var _genderSelected = '';

  @override
  void initState() {
    setState(() {

    });
    super.initState();
    // Get CV Model
    _cvModel = widget.cvModel;
    _initializationData();
    if (widget.masterData != null && _roleNmSelected == null) {
      widget.masterData.summary.forEach((role) {
        _listRoleNm.add(role.role);
      });
    }
  }

  // Fill data when in edit mode
  _initializationData() {
    print('NameCV: ${widget.cvModel.name}');
    _fullNameController.text = widget.cvModel.name ?? kEmpty;
    _emailController.text = widget.cvModel.email ?? kEmpty;
    _positionController.text = widget.cvModel.position ?? kEmpty;
    if (widget.cvModel.gender == null || widget.cvModel.gender.isEmpty) {
      widget.cvModel.gender = 'Mr.';
    } else {
      _genderSelected = widget.cvModel.gender;
    }
    // Get data for Technical Summary
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.masterData != null && _roleNmSelected == null) {
      _listRoleNm.clear();
      widget.masterData.summary.forEach((role) {
        _listRoleNm.add(role.role);
      });
    }
    double sizeWith = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: sizeWith * 0.02),
          child: Container(
            width: MediaQuery.of(context).size.width,
            //  margin: EdgeInsets.symmetric(horizontal: sizeWith * 0.2),
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
                        icon: Icon(
                          Icons.person,
                          size: 16,
                        ),
                        onChanged: (value) {
                          widget.cvModel.name = value;
                        },
                        controller: _generateController('fullNm', widget.cvModel.name),
                        label: 'Full Name',
                        // validator: (name) =>
                        //     Validation().checkValidNameField(context, name),
                      ),
                      _buildGender(context),
                      TextFieldCommon(
                        // validator: (email) =>
                        //     Validation().checkValidPassword(context, email),
                        icon: Icon(
                          Icons.email,
                          size: 16,
                        ),
                        controller: _generateController('email', widget.cvModel.email),
                        label: 'Email',
                        onChanged: (val) {
                          widget.cvModel.email = val;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildAutoComplete(context),
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

  TextEditingController _getValue() {
    TextSelection previousSelection = _fullNameController.selection;
    _fullNameController.text = widget.cvModel.name;
    _fullNameController.selection = previousSelection;
    return _fullNameController;
  }

  Widget _buildAutoComplete(BuildContext context) {
    var sizeWith = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraint) => Autocomplete<String>(
        fieldViewBuilder: (context, controller, focus, func) {
          controller.text = widget.cvModel.position;
          controller.selection =
              TextSelection.collapsed(offset: controller.text.length);
          return TextFieldCommon(
            icon: Icon(
              Icons.work,
              size: 16,
            ),
            onChanged: (val) {
              widget.cvModel.position = val;
            },
            controller: controller,
            focusNode: focus,
            label: 'Position',
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            // return Iterable<String>.empty();
            return _listRoleNm;
          } else {
            return _listRoleNm.where((element) => element
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          }
        },
        optionsViewBuilder: (context, onSelected, options) => OptionViewBuilder(
          onSelected: onSelected,
          constraint: constraint,
          options: options,
        ),
        onSelected: (String selection) {
          setState(() {
            widget.cvModel.position = selection;
          });
        },
      ),
    );
  }
bool _isInit = true;
  // Create gender layout
  Widget _buildGender(BuildContext context) {
    if (_isInit) _genderSelected = widget.cvModel.gender;
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
                    groupValue: _genderSelected,
                    onChanged: (val) {
                      setState(() {
                        _isInit = false;
                        _genderSelected = val;
                        widget.cvModel.gender = val;
                      });
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
                buttonText: 'GENERATE',
                onClick: _roleNmSelected == null ||
                        _technicalSelected == null ||
                        _levelSelected == null
                    ? () => null
                    : () {
                        setState(() {
                          widget.cvModel.technicalSummaryList = widget
                              .masterData
                              .summary[_roleNmSelected]
                              .levels[_levelSelected]
                              .technicals[_technicalSelected]
                              .summaryList;
                        });
                      }),
          ),
          Column(
            children: List.generate(widget.cvModel.technicalSummaryList.length, (index) => _buildTechnicalSumItem(context, widget.cvModel.technicalSummaryList[index], index)),
          ),
          // ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: widget.cvModel.technicalSummaryList.length,
          //     itemBuilder: (context, index) {
          //       final item = widget.cvModel.technicalSummaryList[index];
          //       return _buildTechnicalSumItem(context, item, index);
          //     }),
          Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: AddButton(
              isButtonText: true,
              textButton: 'ADD SUMMARY',
              onPressed: () => setState(() {
                widget.cvModel.technicalSummaryList.add('');
              }),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                          1,
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
    );
  }

  // Technical item
  Widget _buildTechnicalSumItem(
      BuildContext context, String technical, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TextFieldCommon(
            maxLines: 1,
            controller: _generateController('summary-$index', technical),
            onChanged: (val) {
              setState(() {
                widget.cvModel.technicalSummaryList[index] = val;
              });
            },
          )),
          Container(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  // Remove item
                  widget.cvModel.technicalSummaryList.removeAt(index);
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

  Widget _buildConditionsUI(BuildContext context, double width) {
    List<String> _levelNmList = [];
    List<Levels> _levels = [];
    List<Technicals> _technicals = [];
    List<String> _technicalNmList = [];
    if (widget.masterData != null && _roleNmSelected != null) {
      _levelSelected = 0;
      // Get list menu for level and list object for level dropdown
      widget.masterData.summary[_roleNmSelected].levels.forEach((element) {
        // List object level
        _levels.add(element);
        // list menu level dropdown
        _levelNmList.add(element.levelName);
      });
      // Get list technical depend on level selected
      if (_levelSelected != null) {
        _technicals = _levels[_levelSelected].technicals;
        _technicalSelected = 0;
        // Get list menu for technical dropdown
        _technicals.forEach((element) {
          _technicalNmList.add(element.technicalName);
        });
      }
    }

    return Row(
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
            Container(
              height: 40,
              child: ControlTypeDropDown(
                menuList: _listRoleNm,
                initPosition: _roleNmSelected,
                onChange: (val) {
                  setState(() {
                    _roleNmSelected = val;
                  });
                },
              ),
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
            Container(
              height: 40,
              child: ControlTypeDropDown(
                menuList: _levelNmList,
                initPosition: _levelSelected,
                onChange: (val) {
                  setState(() {
                    _levelSelected = val;
                  });
                },
              ),
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
            Container(
              height: 40,
              child: ControlTypeDropDown(
                  menuList: _technicalNmList,
                  initPosition: _technicalSelected,
                  onChange: (val) {
                    setState(() {
                      _technicalSelected = val;
                    });
                  }),
            ),
          ],
        )),
      ],
    );
  }

  // Generate controller by id
  TextEditingController _generateController(String id, String value) {
    var key = id;
    var controller = _controllerMap[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    TextSelection previousSelection = controller.selection;
    controller.text = value;
    controller.selection = previousSelection;
    _controllerMap[key] = controller;
    return controller;
  }
}
