import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';
import 'package:flutter_cv_maker/common/TabModels.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_%20five_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_four_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_one_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_second_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_three_screen.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/common_style.dart';

class CreateCV extends StatefulWidget {
  final CVModel cvModel;
  final int pageINdex;

  const CreateCV({this.cvModel, this.pageINdex});

  @override
  _CreateCVState createState() => _CreateCVState();
}

class _CreateCVState extends State<CreateCV> {
  PageController _pageController = PageController(initialPage: 0);
  List<TabModelSteps> _tab = [];
  CVModel _cvModel;
  MasterData masterData;

  // Page index
  int _pageIndex = 0;

  _addItemsSteps() {
    _tab.add(TabModelSteps(
        numberPage: 0,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_I,
        step: 'Step 1'));
    _tab.add(TabModelSteps(
        numberPage: 1,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_II,
        step: 'Step 2'));
    _tab.add(TabModelSteps(
        numberPage: 2,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_III,
        step: 'Step 3'));
    _tab.add(TabModelSteps(
        numberPage: 3,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_IV,
        step: 'Step 4'));
    _tab.add(TabModelSteps(
        numberPage: 4,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_V,
        step: 'Step 5'));
  }

  _onPageViewChange(int index) {
    setState(() {
      _pageIndex = index;
      _tab.forEach((element) {
        if (element.numberPage <= index) {
          element.colorIcons = true;
        } else {
          element.colorIcons = false;
        }
      });
    });
  }

  @override
  void dispose() {
    print('disposed');
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _fetchMasterData();
    if (widget.cvModel == null) {
      _cvModel = CVModel(
          name: '',
          email: '',
          position: '',
          technicalSummaryList: [],
          status: false,
          gender: 'Male');
    } else {
      _cvModel = widget.cvModel;
    }
    _addItemsSteps();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  // Fetch master data to create/edit cv
  _fetchMasterData() async {
    BlocProvider.of<CVBloc>(context).add(RequestGetCVListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CVBloc, CVState>(
      builder: (context, state) => _buildUI(context),
      listener: (context, state) {
        if (state is CVListLoading) {
          showProgressBar(context, true);
        } else if (state is GetMasterDataSuccess) {
          showProgressBar(context, false);
          setState(() {
            masterData = state.masterData;
          });
          print('MasterData: ${masterData.summary.first.role}');
        } else if (state is GetMasterDataError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is CreateCvSuccess) {
          showProgressBar(context, false);
          print('ID after Create CV: ${state.cvId}');
          widget.cvModel.id = state.cvId;
          print('create cv success');
          showAlertDialog(context, 'Success', 'Create CV  success!', () {
            Navigator.pop(context);
          });
        } else if (state is CreateCvError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is UpdateCvSuccess) {
          showProgressBar(context, false);
          showAlertDialog(context, 'Success', 'Update CV success!',
              () => Navigator.pop(context));
        } else if (state is UpdateCvError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        }
        else if(state is GetDataPositionSuccess){
          showProgressBar(context, false);
        }else if(state is GetDataPositionError){
          showProgressBar(context, false);
        }
      },
      buildWhen: (context, state) =>
          state is GetMasterDataSuccess || state is CreateCvSuccess || state is GetMasterDataSuccess,
    );
  }

  Widget _buildSecondaryPage(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
        color: Color(0xFF000034),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: w * 0.05,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: _buildPreview(context),
                width: w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40))),
              ),
            ),
          ],
        ));
  }

  Widget _buildUI(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _buildMainPageHeader(context),
                    SizedBox(height: 5,),
                     Expanded(child: _pageViewBuild(context)),
                  ],
                )),
            Expanded(
              flex: 4,
              child: _buildSecondaryPage(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageViewBuild(BuildContext context) {
    return PageView(
      onPageChanged: _onPageViewChange,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      children: <Widget>[
        SectionOneScreen(
          cvModel: _cvModel,
          pageController: _pageController,
          masterData: masterData,
        ),
        SecondScreen(
          pageController: _pageController,
          cvModel: _cvModel,
          masterData: masterData,
        ),
        SectionThree(
          pageController: _pageController,
          cvModel: _cvModel,
          initialDate: DateTime.now(),
          masterData: masterData,
        ),
        SectionFour(
          cvModel: _cvModel,
          pageController: _pageController,
          masterData: masterData,
        ),
        SectionFive(
          cvModel: _cvModel,
          pageController: _pageController,
        )
      ],
    );
  }

  Widget _buildMainPageHeader(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        decoration: BoxDecoration(
            color: Color(0xFF000034),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
              bottomRight: Radius.circular(80),
            )),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                navKey.currentState.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,top: 20),
                child: Row(
                  children: [
                    Icon(Icons.home_filled, color: Colors.white,size: 40,),
                    SizedBox(width: 12,),
                    Text(
                      'CV Tool',
                      style: CommonStyle.size48W700White(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            _buildPageSteps(context),
            Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02, top: 50),

            ),
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonCommon(
                      borderRadius: 10,
                      buttonText: 'SAVE CV',
                      onClick: () async {
                        var professionalExp;
                        if (widget.cvModel.professionalList != null && widget.cvModel.professionalList.isNotEmpty) {
                          professionalExp = widget.cvModel.professionalList
                              .firstWhere(
                                  (element) =>
                              element.roleNm.isEmpty ||
                                  element.companyNm.isEmpty ||
                                  element.locationNm.isEmpty ||
                                  element.responsibilities.isEmpty,
                              orElse: () => null);
                        }
                        var projectHighlight;
                        if (widget.cvModel.highLightProjectList != null && widget.cvModel.highLightProjectList.isNotEmpty) {
                          projectHighlight = widget.cvModel.highLightProjectList
                              .firstWhere(
                                  (element) =>
                                  element.projectNm.isEmpty ||
                              element.position.isEmpty ||
                              element.technologies.isEmpty ||
                              element.responsibility.isEmpty ||
                              element.teamSize.isEmpty ||
                              element.projectDescription.isEmpty,
                              orElse: () => null);
                        }

                        if (widget.cvModel.name.isNotEmpty &&
                            widget.cvModel.position.isNotEmpty &&
                            widget.cvModel.email.isNotEmpty &&
                            widget.cvModel.technicalSummaryList.isNotEmpty &&
                            professionalExp == null &&
                            projectHighlight== null &&
                            widget.cvModel.highLightProjectList.isNotEmpty &&
                            widget.cvModel.educationList.isNotEmpty) {
                          setState(() {
                            widget.cvModel.status = true;
                          });
                        } else {
                          setState(() {
                            widget.cvModel.status = false;
                          });
                        }
                        print(widget.cvModel.status);

                        if (widget.cvModel.id != null) {
                          print('EDIT MODE');
                          final pref = await SharedPreferencesService.instance;
                          String requestBody = json.encoder.convert(_cvModel);
                          print(requestBody);
                          BlocProvider.of<CVBloc>(context).add(
                              RequestUpdateCvEvent(pref.getAccessToken,
                                  requestBody, _cvModel.id));
                        } else {
                          print('CREATE MODE');
                          final pref = await SharedPreferencesService.instance;
                          String requestBody = json.encoder.convert(_cvModel);
                          print(requestBody);
                          BlocProvider.of<CVBloc>(context).add(
                              RequestCreateCvEvent(
                                  pref.getAccessToken, requestBody));
                        }
                      }),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildPageSteps(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.05
      ),
      child: Row(
        children: _tab
            .map((e) => _buildStepItem(context, e, _tab.indexOf(e)))
            .toList(),
      ),
    );
  }

  Widget _buildStepItem(
      BuildContext context, TabModelSteps modelSteps, int index) {
    return Container(
      // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.006),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    modelSteps.numberPage,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  );
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.015,
              height: MediaQuery.of(context).size.width * 0.015,
              decoration: BoxDecoration(
                color: _pageIndex == modelSteps.numberPage
                    ? Colors.white
                    : modelSteps.colorIcons
                        ? Colors.greenAccent.shade400
                        : Colors.grey,
                border: Border.all(
                    color: _pageIndex == modelSteps.numberPage
                        ? Colors.blue
                        : modelSteps.colorIcons
                            ? Colors.greenAccent.shade400
                            : Colors.black26,
                    width: 2),
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text('${modelSteps.numberPage + 1}',
                  style: CommonStyle.main700Size18(context).copyWith(
                    fontSize: 10,
                    color: _pageIndex == modelSteps.numberPage
                        ? Colors.blue
                        : modelSteps.colorIcons
                            ? Colors.white
                            : Colors.black,
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(modelSteps.step,
                    style: CommonStyle.size8grey(context).copyWith(
                        fontSize: 10,
                        color: index == _pageIndex
                            ? Color(0xffF6C6EA)
                            : Colors.grey,
                        fontWeight: FontWeight.w700)),
                Text(
                  modelSteps.title,
                  style: CommonStyle.size8grey(context).copyWith(fontSize: 10),
                )
              ],
            ),
          ),
          modelSteps.horizontalLine == true
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.047,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tab[index].title != SECTION_V
                          ? Divider(
                              color: modelSteps.colorIcons
                                  ? Colors.greenAccent.shade400
                                  : Colors.tealAccent)
                          : Container(
                        width: 0,
                        height: 0,
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _buildPreview(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                widget.cvModel.name + ' (${widget.cvModel.gender})',
                style: CommonStyle.size10W700black(context).copyWith(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                widget.cvModel.position.toUpperCase() ?? kEmpty,
                style: GoogleFonts.caladea(fontSize: 16, color: Colors.black)
              ),
            ),
            widget.cvModel.email.isNotEmpty ?
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Text('Email: ${widget.cvModel.email}',
                    style: CommonStyle.size8W400black(context))) :Container(),
            widget.cvModel.technicalSummaryList.isNotEmpty
                ? _buildSectionTitle(context, 'Professional summary')
                : Container(),
            widget.cvModel.technicalSummaryList.isNotEmpty
                ? _buildProfessional(context)
                : Container(),
            widget.cvModel.educationList.isNotEmpty
                ? _buildSectionTitle(context, 'Education')
                : Container(),
            widget.cvModel.educationList.isNotEmpty
                ? _buildEducation(context)
                : Container(),
            widget.cvModel.technicalSummaryList.isNotEmpty
                ? _buildSectionTitle(context, 'Technical Skills')
                : Container(),
            widget.cvModel.technicalSummaryList.isNotEmpty
                ? _buildTechnicalSkills(context)
                : Container(),
            widget.cvModel.professionalList.isNotEmpty
                ? _buildSectionTitle(context, 'Professional Experience')
                : Container(),
            widget.cvModel.professionalList.isNotEmpty
                ? _buildProfessionalExperiences(context)
                : Container(),
            widget.cvModel.certificateList.isNotEmpty
                ? _buildCertificates(context)
                : Container(),
            widget.cvModel.highLightProjectList.isNotEmpty
                ? _buildHighLightProjects(context)
                : Container(),
            widget.cvModel.languages != null &&
                    widget.cvModel.languages.isNotEmpty
                ? _buildSectionTitle(context, 'Languages')
                : Container(),
            widget.cvModel.languages != null &&
                    widget.cvModel.languages.isNotEmpty
                ? _buildLanguage(context)
                : Container(),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
  Widget _buildCertificates(context) {

    return Column(
      children: [
        _buildSectionTitle(context, 'Certificates'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            children: List.generate(widget.cvModel.certificateList.length, (index) => Row(
              children: [
                Expanded(child: Text(widget.cvModel.certificateList[index].certificateNm, style: CommonStyle.size8W400black(context)),),
                Text(widget.cvModel.certificateList[index].certificateYear, style: CommonStyle.size8W400black(context))
              ],
            )),
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: CommonStyle.size10W700black(context).copyWith(fontSize: 12)),
          Divider(
            color: Colors.black,
            height: 1,
          )
        ],
      ),
    );
  }

  Widget _buildProfessional(BuildContext context) {
    return Column(
      children: widget.cvModel.technicalSummaryList
          .map((summary) => _buildProfessionalItem(context, summary))
          .toList(),
    );
  }

  // Create Professional item
  Widget _buildProfessionalItem(BuildContext context, String summaryItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.black,
            size: 8,
          ),
          SizedBox(width: 10.0),
          Text(
            summaryItem,
            style: CommonStyle.size8W400black(context),
          )
        ],
      ),
    );
  }
  // Build Education list
  Widget _buildEducation(BuildContext context) {
    return Column(
      children: widget.cvModel.educationList
          .map((education) => _buildEducationItem(context, education))
          .toList(),
    );
  }

  // Build Education item
  Widget _buildEducationItem(BuildContext context, EducationList education) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${education.schoolNm} - class of ${education.classYear}',
            style: CommonStyle.size8W400black(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Major: ${education.majorNm}',
                style: CommonStyle.size8W400black(context)),
          )
        ],
      ),
    );
  }

  // Build Technical skill list
  Widget _buildTechnicalSkills(BuildContext context) {
    return Column(
      children: widget.cvModel.skills
          .map((skill) => _buildTechnicalSkillItem(context, skill))
          .toList(),
    );
  }

  // Build Technical skill item
  Widget _buildTechnicalSkillItem(BuildContext context, Skills skill) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '${skill.skillNm}: ',
                style: CommonStyle.size8W400black(context)),
            TextSpan(
                text: skill.skillData,
                style: CommonStyle.size8W400black(context)),
          ]))
        ],
      ),
    );
  }

  Widget _buildProfessionalExperiences(BuildContext context) {
    return Column(
      children: widget.cvModel.professionalList
          .map((professional) =>
              _buildProfessionalExperienceItem(context, professional))
          .toList(),
    );
  }

  // Build Professional Experience item
  Widget _buildProfessionalExperienceItem(
      BuildContext context, ProfessionalList professional) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichTextCommonPreview(
                boldText: '${professional.companyNm}, ',
                regularText: professional.locationNm,
                size: 6,
              ),
              Spacer(),
              Text(
                '${professional.startDate} - ${professional.endDate}',
                style: CommonStyle.size8W400black(context),
              )
            ],
          ),
          SizedBox(height: 4.0),
          RichTextCommonPreview(
            boldText: 'Role: ',
            regularText: professional.roleNm,
            size: 6,
          ),
          SizedBox(height: 4.0),
          Text(
            'Responsibilities:'.toUpperCase(),
            style: CommonStyle.size10W700black(context).copyWith(fontSize: 12),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: professional.responsibilities
                  .map((responsibility) => BulletPreview(
                        text: responsibility,
                        isFill: false,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  // Build highlight project
  Widget _buildHighLightProjects(BuildContext context) {
    print('sjdfklsdkfde ${widget.cvModel.highLightProjectList.first.projectNm}');
    if (widget.cvModel.highLightProjectList.isEmpty ||
        widget.cvModel.highLightProjectList.first.projectNm.isEmpty)
      return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(context, 'Highlight Project'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.cvModel.highLightProjectList
              .map((highLightProject) =>
                  _buildHighLightProjectItem(context, highLightProject))
              .toList(),
        )
      ],
    );
  }

  // Build highlight project item
  Widget _buildHighLightProjectItem(
      BuildContext context, HighLightProjectList highLightProject) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              highLightProject.projectNm ?? kEmpty,
              style: CommonStyle.size10W700black(context)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
          Table(
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(6),
            },
            border: TableBorder.all(color: Colors.black),
            children: [
             if(highLightProject.projectDescription.isNotEmpty)_buildTableRow(context, 'Project Description',
                  highLightProject.projectDescription) ,
             if( highLightProject.teamSize.isNotEmpty)  _buildTableRow(context, 'Team size', highLightProject.teamSize),
             if(highLightProject.position.isNotEmpty ) _buildTableRow(context, 'Position', highLightProject.position),
              if(highLightProject.responsibility.isNotEmpty )_buildTableRow(context, 'Responsibility',
                   _getDataResponsibility(highLightProject.responsibility)) ,
             if( highLightProject.technologies.isNotEmpty ) _buildTableRow(context, 'Technology used',
                   highLightProject.technologies.join(', ').toString()),
             if( highLightProject.communicationused.isNotEmpty) _buildTableRow(context, 'Communication used ',
                  highLightProject.communicationused),
             if(highLightProject.uiuxdesign.isNotEmpty ) _buildTableRow(
                  context, 'UI&UX design ', highLightProject.uiuxdesign),
             if(highLightProject.documentcontrol.isNotEmpty ) _buildTableRow(context, 'Document Control ',
                  highLightProject.documentcontrol),
            if(highLightProject.projectmanagementtool.isNotEmpty ) _buildTableRow(context, 'Project management tool ',
                  highLightProject.projectmanagementtool),
            ],
          ),
        ],
      ),
    );
  }

  String _getDataResponsibility(List<String> responsibilities) {
    String a = '';
    responsibilities.forEach((element) {
      a = a.isEmpty ? '+ $element' : '$a' + '\n+ $element';
    });
    return a;
  }

  TableRow _buildTableRow(BuildContext context, String title, String content) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child:
            Text(title ?? kEmpty, style: CommonStyle.size8W400black(context)),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child:
            Text(content ?? kEmpty, style: CommonStyle.size8W400black(context)),
      ),
    ]);
  }

  // Build language project
  Widget _buildLanguage(BuildContext context) {
    return Column(
      children: widget.cvModel.languages
          .map((language) => _buildLanguageItem(context, language))
          .toList(),
    );
  }

  // Build language project item
  Widget _buildLanguageItem(BuildContext context, Languages language) {
    return Padding(
      padding: EdgeInsets.only(left: 35),
      child: Row(
        children: [
          Text('${language.languageNm}:',
              style: CommonStyle.size10W700black(context).copyWith(fontSize: 12)),
          SizedBox(width: 10),
          Text(language.level, style: CommonStyle.size8W400black(context)),
        ],
      ),
    );
  }
}
