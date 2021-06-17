import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';

class RolePage extends StatefulWidget {
  final MasterData masterData;

  const RolePage({this.masterData});

  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  // Map controllerEditText id
  Map<String, TextEditingController> _technicalController = {};

  @override
  Widget build(BuildContext context) {
    return _buildPageForms(context);
  }

  Widget _buildPageForms(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HorizontalLine('Technical summary'),
            SizedBox(
              height: 15,
            ),
            _buildListRole(context),
            AddButton(
              onPressed: () {
                setState(() {
                  widget.masterData.roles
                      .add(RoleData(levelDataList: [], roleNm: ''));
                });
              },
              isButtonText: true,
              textButton: 'ADD ROLE',
            )
          ],
        ),
      ),
    );
  }

  // Build list role
  Widget _buildListRole(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: widget.masterData.roles
                .map((role) => _buildRoleItem(
                    context, role, widget.masterData.roles.indexOf(role)))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Create role item
  Widget _buildRoleItem(BuildContext context, RoleData roleData, int index) {
    return Container(
        margin: EdgeInsets.only(top: 4.0),
        padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      // Remove item
                      widget.masterData.roles.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            TextFieldCommon(
              controller: _generateController('role-$index', roleData.roleNm),
              label: 'Role',
              hint: 'Role',
              onChanged: (value) {
                setState(() {
                  roleData.roleNm = value;
                });
              },
            ),
            _buildLevel(context, roleData.levelDataList, 'role-$index'),
            AddButton(
              isButtonText: true,
              textButton: 'ADD LEVEL',
              onPressed: () {
                setState(() {
                  roleData.levelDataList
                      .add(LevelData(levelName: '', technicalDataList: []));
                });
              },
            ),
          ],
        ));
  }

  Widget _buildLevel(
      BuildContext context, List<LevelData> levelDataList, String roleId) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Column(
            children: levelDataList
                .map((e) => _buildLevelItem(context, levelDataList, e,
                    levelDataList.indexOf(e), roleId))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelItem(BuildContext context, List<LevelData> levelDataList,
      LevelData levelData, int index, String roleId) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xFFedf4ff),
          border: Border.all(color: Color(0xffccdfff), width: 1)),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      levelDataList.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Colors.red,
                  ))
            ],
          ),
          TextFieldCommon(
            label: 'Level',
            controller: _generateController(
                'level-$index-$roleId', levelData.levelName),
            onChanged: (val) {
              setState(() {
                levelData.levelName = val;
              });
            },
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Icon(
                Icons.military_tech_rounded,
                color: Color(0xff045cfc),
              ),
              Text(
                'Technicals',
                style: CommonStyle.size16W400hintTitle(context)
                    .copyWith(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _buildTechnical(
              context, levelData.technicalDataList, 'level-$index-$roleId')
        ],
      ),
    );
  }

  Widget _buildTechnical(
      BuildContext context, List<String> technicalList, String levelId) {
    return Column(
      children: [
        Column(
          children: technicalList
              .map((e) => _buildTechnicalItem(context, technicalList, e,
                  technicalList.indexOf(e), '$levelId'))
              .toList(),
        ),
        AddButton(
          isButtonText: true,
          textButton: 'ADD TECHNICAL',
          onPressed: () {
            setState(() {
              technicalList.add('');
            });
          },
        )
      ],
    );
  }

  Widget _buildTechnicalItem(BuildContext context, List<String> technicalList,
      String value, int index, String levelId) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              label: 'Technical',
              controller:
                  _generateController('technical-$index-$levelId', value),
              onChanged: (val) {
                setState(() {
                  technicalList[index] = val;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  technicalList.removeAt(index);
                });
              },
              icon: Icon(Icons.close))
        ],
      ),
    );
  }

  TextEditingController _generateController(String id, String value) {
    var key = id;
    TextEditingController controller = _technicalController[key];
    if (controller == null) {
      controller = TextEditingController();
    }
    controller.text = value;
    _technicalController[key] = controller;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return controller;
  }
}
