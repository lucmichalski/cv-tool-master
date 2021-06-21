import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/master_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/highlight_page.dart';
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
  MasterData _masterData = MasterData(skills: [], technicalUsed: [], summary: [
    Summary(role: '', levels: [Levels(levelName: '', technicals: [])])
  ]);

  // Role page ID
  static const int ROLE_PAGE_ID = 0;

  // Skill page ID
  static const int SKILL_PAGE_ID = 1;

  // Highlight page ID
  static const int HIGHLIGHT_PAGE_ID = 2;

  // page selected
  int _pageId = 0;

  @override
  void initState() {
    _fetchMasterData();
    super.initState();
  }

  // Get master data API
  _fetchMasterData() async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<MasterBloc>(context).add(RequestGetMasterEvent(pref.getAccessToken));
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return BlocConsumer<MasterBloc, MasterState>(
        builder: (context, state) => _buildMasterData(context, w),
        listener: (context, state) {
          if (state is MasterLoading) {
            showProgressBar(context, true);
          } else if (state is MasterSuccess) {
            showProgressBar(context, false);
            print('success');
          } else if (state is MasterError) {
            showProgressBar(context, false);
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          } else if (state is UpdateMasterSuccess) {
            showProgressBar(context, false);
            showAlertDialog(
                context, 'Success', 'Update master data success!', () => Navigator.pop(context));
          } else if (state is UpdateMasterError) {
            showProgressBar(context, false);
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          } else if (state is GetMasterSuccess) {
            showProgressBar(context, false);
            if (state.masterData != null) {
              _masterData = state.masterData;
            }
          } else if (state is GetMasterError) {
            showProgressBar(context, false);
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          }
        });
  }

  Widget _buildMasterData(BuildContext context, var w) {
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
    switch (pageId) {
      case ROLE_PAGE_ID:
        return RolePage(
          masterData: _masterData,
          onPress: () {
            setState(() {
              _pageId = SKILL_PAGE_ID;
            });
          },
        );
        break;
      case SKILL_PAGE_ID:
        return SkillPage(
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
        return HighlightPage(
          masterData: _masterData,
          onPrevious: () {
            setState(() {
              _pageId = SKILL_PAGE_ID;
            });
          },
        );
        break;

      default:
        return RolePage(
          masterData: _masterData,
        );
        break;
    }
  }

  // Build Menu Nav
  Widget _buildMenuNav(BuildContext context, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: () => setState(() => _pageId = ROLE_PAGE_ID),
            child: _buildMenuItem(
                context, ROLE_PAGE_ID, 'Role'.toUpperCase(), isNarrow)),
        InkWell(
            onTap: () => setState(() => _pageId = SKILL_PAGE_ID),
            child: _buildMenuItem(
                context, SKILL_PAGE_ID, 'Skill'.toUpperCase(), isNarrow)),
        InkWell(
            onTap: () => setState(() => _pageId = HIGHLIGHT_PAGE_ID),
            child: _buildMenuItem(context, HIGHLIGHT_PAGE_ID,
                'Technical'.toUpperCase(), isNarrow)),
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
