import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/highlight_page.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/role_page.dart';
import 'package:flutter_cv_maker/screens/adminpage/role_page/skill_page.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool showLevelView = false;
  bool showTechnicalView = false;
  MasterData _masterData = MasterData(roles: [
    RoleData(
        roleNm: '',
        levelDataList: [LevelData(levelName: '', technicalDataList: [])])
  ]);

  // Role page ID
  static const int ROLE_PAGE_ID = 0;

  // Skill page ID
  static const int SKILL_PAGE_ID = 1;

  // Highlight page ID
  static const int HIGHLIGHT_PAGE_ID = 2;

  // page selected
  int pageId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          var a = constraints.maxWidth;
          print('Width: $a');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color(0xffBBDEFB),
                width: a < 1000 ? w * 0.05 : w * 0.2,
                child: _buildMenuNav(context),
              ),
              Expanded(child: _handleSwitchPage(context, pageId))
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
        );
        break;
      case SKILL_PAGE_ID:
        return SkillPage(
          masterData: _masterData,
        );
        break;
      case HIGHLIGHT_PAGE_ID:
        return HighlightPage(
          masterData: _masterData,
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
  Widget _buildMenuNav(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuItem(context, ROLE_PAGE_ID, 'Role'),
        _buildMenuItem(context, SKILL_PAGE_ID, 'Skill'),
        _buildMenuItem(context, HIGHLIGHT_PAGE_ID, 'Highlight'),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, int index, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        children: [
          _buildCirclePage(context, index),
          SizedBox(
            width: 16,
          ),
          LinkText(
            text: '$title',
            color: index == pageId ? Colors.blue : Colors.black,
            onTapLink: () {
              setState(() {
                pageId = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCirclePage(BuildContext context, int pageIndex) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.03,
      height: MediaQuery.of(context).size.width * 0.03,
      decoration: BoxDecoration(
        color: pageIndex == pageId ? Colors.white : Colors.greenAccent.shade400,
        border: Border.all(
            color:
                pageIndex == pageId ? Colors.blue : Colors.greenAccent.shade400,
            width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: Text('${pageIndex + 1}',
          style: CommonStyle.main700Size18(context).copyWith(
              color: pageIndex == pageId ? Colors.blue : Colors.white)),
    );
  }
}
