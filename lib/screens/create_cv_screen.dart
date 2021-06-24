import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/master_bloc.dart';
import 'package:flutter_cv_maker/common/TabModels.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/helper.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_%20five_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_four_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_one_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_second_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_three_screen.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

import '../common/common_style.dart';

class CreateCV extends StatefulWidget {
  final CVModel cvModel;
  final int pageINdex;
  const CreateCV({this.cvModel, this.pageINdex});

  @override
  _CreateCVState createState() => _CreateCVState();
}

class _CreateCVState extends State<CreateCV> {
   PageController controller = PageController(initialPage: 0);
  final PageController _pageController = PageController();
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
    controller = PageController(initialPage: 0);
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
          print('create cv success');
          showAlertDialog(context, 'Success', 'Create CV  success!',
              () => navKey.currentState.pushNamed(
                  routeHome));
        } else if (state is CreateCvError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is UpdateCvSuccess) {
          showProgressBar(context, false);
          showAlertDialog(context, 'Success', 'Update CV success!',
              () => navKey.currentState.pushNamed(
                  routeHome));

        } else if (state is UpdateCvError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        }
      },
      buildWhen: (context, state) => state is GetMasterDataSuccess,
    );
  }
  Widget _buildSecondaryPage(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
        color: Color(0xFF000034),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  LinkText(
                      text: 'Home Page',
                      color: Colors.white,
                      onTapLink: () {
                        navKey.currentState.pushNamed(
                            routeHome);
                      }),
                  SizedBox(
                    width: w * 0.05,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                 child:_buildPreview(context),
                width: w,
                // height: MediaQuery.of(context).size.height,
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
                  //SizedBox(height: 5,),
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
  Widget _pageViewBuild(BuildContext context){
    return  PageView(
      onPageChanged: _onPageViewChange,
      scrollDirection: Axis.horizontal,
      controller: controller,
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
                Padding(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02),
                  child: Text(
                    'CV Tool',
                    style: CommonStyle.size48W700White(context),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildPageSteps(context),
                Container(
                  padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.02,top: 50),
                  child: Text(
                    'Recent Add',
                    style: CommonStyle.size48W700White(context)
                        .copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(right:MediaQuery.of(context).size.width*0.05 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonCommon(
                        borderRadius: 10,
                          buttonText: 'SAVE CV',
                          onClick: () async {
                            if(widget.cvModel.name.isNotEmpty && widget.cvModel.position.isNotEmpty && widget.cvModel.email.isNotEmpty
                                && widget.cvModel.technicalSummaryList.isNotEmpty && widget.cvModel.certificateList.isNotEmpty
                                && widget.cvModel.professionalList.isNotEmpty && widget.cvModel.highLightProjectList.isNotEmpty && widget.cvModel.educationList.isNotEmpty)
                            {
                             setState(() {
                               widget.cvModel.status = true;
                             });
                            }else{
                              setState(() {
                                widget.cvModel.status = false;
                              });
                            }
                          print(widget.cvModel.status);

                            if (widget.cvModel.id != null) {

                              final pref = await SharedPreferencesService.instance;
                              String requestBody = json.encoder.convert(_cvModel);
                              print(requestBody);
                              BlocProvider.of<CVBloc>(context).add(RequestUpdateCvEvent(
                                  pref.getAccessToken, requestBody, _cvModel.id));
                            } else {
                              final pref = await SharedPreferencesService.instance;
                              String requestBody = json.encoder.convert(_cvModel);
                              print(requestBody);
                              BlocProvider.of<CVBloc>(context).add(RequestCreateCvEvent(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          _tab.map((e) => _buildStepItem(context, e, _tab.indexOf(e))).toList(),
    );
  }

  Widget _buildStepItem(
      BuildContext context, TabModelSteps modelSteps, int index) {
    return Container(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.006),
      child: Row(
        children: [
          InkWell(
            onTap: (){
              setState(() {
                if (controller.hasClients) {
                  controller.animateToPage(
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
                        : Color(0xffFFFF99),
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
                  style: CommonStyle.main700Size18(context).copyWith(fontSize: 10,
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
                Text(
                  modelSteps.step,
                  style:CommonStyle.size8grey(context).copyWith(fontSize: 10,color: index == _pageIndex ? Color(0xffF6C6EA) : Colors.grey,
                      fontWeight: FontWeight.w700)
                ),
                Text(
                  modelSteps.title,
                  style:CommonStyle.size8grey(context).copyWith(fontSize: 10)
                      ,
                )
              ],
            ),
          ),
          modelSteps.horizontalLine == true
              ? Container(
                  width: MediaQuery.of(context).size.width *0.055,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tab[index].title != SECTION_V
                          ? Divider(
                              color: modelSteps.colorIcons
                                  ? Colors.greenAccent.shade400
                                  : Colors.tealAccent)
                          : Container(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
  _buildPreview(BuildContext context){
    return  SingleChildScrollView(
        child:   Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  widget.cvModel.name + '(${widget.cvModel.gender})',
                  style: CommonStyle.size10W700black(context),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                widget.cvModel.position ?? kEmpty,
                style: CommonStyle.size10W700black(context),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  child: Text('Email: ${widget.cvModel.email}',
                      style: CommonStyle.size8W400black(context))),
              widget.cvModel.technicalSummaryList.isNotEmpty ? _buildSectionTitle(context, 'Professional summary') : Container(),
              widget.cvModel.technicalSummaryList.isNotEmpty ?  _buildProfessional(context) :Container(),
              widget.cvModel.educationList.isNotEmpty ? _buildSectionTitle(context, 'Education') :Container(),
              widget.cvModel.educationList.isNotEmpty ?  _buildEducation(context) :Container(),
              widget.cvModel.technicalSummaryList.isNotEmpty ? _buildSectionTitle(context, 'Technical Skills'):Container(),
              widget.cvModel.technicalSummaryList.isNotEmpty ? _buildTechnicalSkills(context) :Container(),
              widget.cvModel.professionalList.isNotEmpty ? _buildSectionTitle(context, 'Professional Experience'):Container(),
              widget.cvModel.professionalList.isNotEmpty  ?  _buildProfessionalExperiences(context):Container(),
              widget.cvModel.highLightProjectList.isNotEmpty ?  _buildHighLightProjects(context) : Container(),
              //   _buildSectionTitle(context, 'Languages'),
              // widget.cvModel.languages.isNotEmpty ? _buildLanguage(context): Container(),
            ],
          ),
        ),
    );
  }
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CommonStyle.size10W700black(context)),
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
                style: CommonStyle.size10W700black(context)),
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
              RichTextCommon(
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
          RichTextCommon(
            boldText: 'Role: ',
            regularText: professional.roleNm,
            size: 6,
          ),
          SizedBox(height: 4.0),
          Text(
            'Responsibilities:',
            style: CommonStyle.size10W700black(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: professional.responsibilities
                  .map((responsibility) => Bullet(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(context, 'HighLight Project'),
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
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(4),
            },
            border: TableBorder.all(color: Colors.black),
            children: [
              _buildTableRow(context, 'Project Description',
                  highLightProject.projectDescription),
              _buildTableRow(context, 'Team size', highLightProject.teamSize),
              _buildTableRow(context, 'Position', highLightProject.position),
              _buildTableRow(context, 'Responsibility',
                  _getDataResponsibility(highLightProject.responsibility)),
              _buildTableRow(context, 'Technology used',
                  highLightProject.technologies.join(', ').toString()),
              _buildTableRow(context, 'Communication used ',
                  highLightProject.communicationused),
              _buildTableRow(context, 'UI&UX design ',
                  highLightProject.uiuxdesign),
              _buildTableRow(context, 'Document Control ',
                  highLightProject.documentcontrol),
              _buildTableRow(context, 'Project management tool ',
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
        padding: EdgeInsets.all(16.0),
        child: Text(title ?? kEmpty, style: CommonStyle.size8W400black(context)),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(content ?? kEmpty, style: CommonStyle.size8W400black(context)),
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
              style: CommonStyle.size10W700black(context)),
          SizedBox(width: 10),
          Text(language.level, style: CommonStyle.size8W400black(context)),
        ],
      ),
    );
  }

}
