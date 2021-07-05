import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/master_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/company_page.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/highlight_page.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/project_page.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/role_page.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/skill_page.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool showLevelView = false;
  bool showTechnicalView = false;
  MasterData _masterData =
      MasterData(skills: [], technicalUsed: [], companyMaster: [
    CompanyMaster(role: '', responsibilities: [''])
  ], projectMaster: [
    ProjectMaster(role: '', responsibilities: [''])
  ], summary: [
    Summary(
      role: '',
      levels: [Levels(levelName: '', technicals: [])],
    ),
  ]);

  // Role page ID
  static const int ROLE_PAGE_ID = 0;

  // Skill page ID
  static const int SKILL_PAGE_ID = 4;

  // Highlight page ID
  static const int HIGHLIGHT_PAGE_ID = 1;
  static const int COMPANY_PAGE_ID = 2;
  static const int PROJECT_PAGE_ID = 3;

  // page selected
  int _pageId = 0;
  // Current ID
  String _masterId = kEmpty;
  bool _isInit = false;

  @override
  void initState() {
    _fetchMasterData();
    super.initState();
  }

  // Get master data API
  _fetchMasterData() async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<MasterBloc>(context)
        .add(RequestGetMasterEvent(pref.getAccessToken));
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MasterBloc, MasterState>(
      builder: (context, state) => _buildUI(context),
      listener: (context, state) {
        if (state is MasterLoading) {
           showProgressBar(context, true);
        } else if (state is MasterSuccess) {
          showProgressBar(context, false);
          _isInit = true;
          _masterId = state.msg;
          showAlertDialog(context, 'Success', 'Add master data success!',
                  () => Navigator.pop(context));
          print('success');
        } else if (state is MasterError) {
          _isInit = false;
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is UpdateMasterSuccess) {
          _isInit = false;
          showProgressBar(context, false);
          print('Update Success');
          showAlertDialog(context, 'Success', 'Update master data success!',
              () => Navigator.pop(context));
        } else if (state is UpdateMasterError) {
          _isInit = false;
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is GetMasterSuccess) {
          _isInit = false;
          showProgressBar(context, false);
          if (state.masterData != null) {
            _masterData = state.masterData;
            if (_masterData.companyMaster == null ||
                _masterData.companyMaster.isEmpty) {
              _masterData.companyMaster
                  .add(CompanyMaster(role: '', responsibilities: ['']));
            }
          }
        } else if (state is GetMasterError) {
          _isInit = false;
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        }
      },
      buildWhen: (context, state) =>
          state is MasterSuccess ||
          // state is UpdateMasterSuccess ||
          state is GetMasterSuccess,
    );
  }

  Widget _buildUI(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff6f8fa),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var maxW = constraints.maxWidth;
          print('Width: $maxW');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                width: maxW < 1000 ? w * 0.09 : w * 0.2,
                child: _buildMenuNav(context, maxW < 1000),
              ),
              Expanded(child: _handleSwitchPage(context, _pageId))
            ],
          );
        },
      ),
    );
  }

  // Handle switch pages
  Widget _handleSwitchPage(BuildContext context, int pageId) {
    Widget screen;
    switch (pageId) {
      case ROLE_PAGE_ID:
        screen = RolePage(
          masterData: _masterData,
          isInit: _isInit,
          onPress: () {
            setState(() {
              _pageId = SKILL_PAGE_ID;
            });
          },
        );
        break;
      case SKILL_PAGE_ID:
        screen = SkillPage(
          onNext: () {
            setState(() {
              _pageId = HIGHLIGHT_PAGE_ID;
            });
          },
          onPrevious: () {
            {
              setState(() {
                _pageId = ROLE_PAGE_ID;
              });
            }
          },
          masterData: _masterData,
        );
        break;
      case HIGHLIGHT_PAGE_ID:
        screen = HighlightPage(
          masterData: _masterData,
          onPrevious: () {
            setState(() {
              _pageId = SKILL_PAGE_ID;
            });
          },
        );
        break;
      case COMPANY_PAGE_ID:
        screen = CompanyPage(
          masterData: _masterData,
          onPrevious: () {
            setState(() {
              _pageId = COMPANY_PAGE_ID;
            });
          },
        );
        break;
      case PROJECT_PAGE_ID:
        screen = ProjectPage(
          masterData: _masterData,
          onPrevious: () {
            setState(() {
              _pageId = PROJECT_PAGE_ID;
            });
          },
        );
        break;
      default:
        screen = RolePage(
          masterData: _masterData,
        );
        break;
    }

    return Column(
      children: [
        Expanded(child: screen),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonCommon(
                  buttonText: 'SAVE',
                  onClick: () async {
                    final String requestBody =
                        json.encoder.convert(_masterData);
                    final pref = await SharedPreferencesService.instance;
                    if (_masterData.id == null && _masterId == kEmpty) {
                      print('Create Mode');
                      // Create mode
                      BlocProvider.of<MasterBloc>(context).add(
                          RequestAddMasterEvent(
                              pref.getAccessToken, requestBody));
                    } else {
                      print('Edit Mode');
                      // Update mode
                      BlocProvider.of<MasterBloc>(context).add(
                          RequestUpdateMasterEvent(
                              pref.getAccessToken, requestBody));
                    }
                    print(requestBody);
                  }),
            ],
          ),
        )
      ],
    );
  }

  // Build Menu Nav
  Widget _buildMenuNav(BuildContext context, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home,size: 30,color: Colors.blue,),
            SizedBox(width: 10,),
            LinkText(
                text: 'Home Page',
                linkTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700),
                onTapLink: () => Navigator.pop(context))
          ],
        ),
        SizedBox(height: 30,),
        InkWell(
            onTap: () => setState(() => _pageId = ROLE_PAGE_ID),
            child: _buildMenuItem(context, ROLE_PAGE_ID,
                'Technical summary'.toUpperCase(), isNarrow)),
        InkWell(
            onTap: () => setState(() => _pageId = HIGHLIGHT_PAGE_ID),
            child: _buildMenuItem(context, HIGHLIGHT_PAGE_ID,
                'Highlight project technical'.toUpperCase(), isNarrow)),
        InkWell(
            onTap: () => setState(() => _pageId = COMPANY_PAGE_ID),
            child: _buildMenuItem(context, COMPANY_PAGE_ID,
                'Company responsibility'.toUpperCase(), isNarrow)),
        InkWell(
            onTap: () => setState(() => _pageId = PROJECT_PAGE_ID),
            child: _buildMenuItem(context, PROJECT_PAGE_ID,
                'Project responsibilities'.toUpperCase(), isNarrow)),
        InkWell(
            onTap: () => setState(() => _pageId = SKILL_PAGE_ID),
            child: _buildMenuItem(
                context, SKILL_PAGE_ID, 'Skill'.toUpperCase(), isNarrow)),




      ],
    );
  }

  Widget _buildMenuItem(
      BuildContext context, int index, String title, bool isNarrow) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          children: [
            _buildCirclePage(context, index),
            Visibility(
              visible: !isNarrow,
              child: SizedBox(
                width: 10,
              ),
            ),
            Visibility(
              visible: !isNarrow,
              child: LinkText(
                text: '$title',
                color: index == _pageId
                    ? Color(0xff045cfc)
                    : index < _pageId
                        ? Color(0xffd3d9e1)
                        : Color(0xff565d75),
                onTapLink: () {
                  setState(() {
                    _pageId = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCirclePage(BuildContext context, int pageIndex) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.03,
      height: MediaQuery.of(context).size.width * 0.03,
      decoration: BoxDecoration(
        color: pageIndex == _pageId
            ? Colors.white
            : pageIndex < _pageId
                ? Colors.greenAccent.shade400
                : Colors.white,
        border: Border.all(
            color: pageIndex == _pageId
                ? Color(0xff045cfc)
                : pageIndex < _pageId
                    ? Colors.greenAccent.shade400
                    : Colors.grey.shade400,
            width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: Text('${pageIndex + 1}',
          style: CommonStyle.main700Size18(context).copyWith(
            color: pageIndex == _pageId
                ? Color(0xff045cfc)
                : pageIndex < _pageId
                    ? Colors.white
                    : Colors.grey.shade400,
          )),
    );
  }
}
