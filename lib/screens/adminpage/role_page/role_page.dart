import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/expanded_section.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';

class RolePage extends StatefulWidget {
  final MasterData masterData;
  final Function onPress;
  final bool isInit;

  RolePage({this.masterData, this.onPress, this.isInit});

  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  // Map controllerEditText id
  Map<String, TextEditingController> _technicalController = {};

  @override
  void initState() {
    // TODO: implement initState
    if (widget.masterData.summary.isEmpty)
      widget.masterData.summary.add(Summary(levels: [], role: ''));
    super.initState();
  }

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
                  widget.masterData.summary.add(Summary(levels: [], role: '',isExpand: false));
                });
              },
              isButtonText: true,
              textButton: 'ADD ROLE',
            ),
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
            children: widget.masterData.summary
                .map((role) => _buildRoleItem(
                    context, role, widget.masterData.summary.indexOf(role)))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Create role item
  Widget _buildRoleItem(BuildContext context, Summary summary, int index) {
    return Container(
        margin: EdgeInsets.only(top: 4.0),
        padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    tooltip: summary.isExpand ? 'Collapse' : 'Expand',
                    hoverColor: Colors.transparent,
                    splashRadius: 1,
                    onPressed: () {
                      setState(() {
                        print('Tap expand: ${summary.isExpand}');
                        summary.isExpand = !summary.isExpand;
                      });
                    },
                    icon: Icon(Icons.wrap_text)),
                Spacer(),
                IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      // Remove item
                      widget.masterData.summary.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            TextFieldCommon(
              controller: _generateController('role-$index', summary.role),
              label: 'Role',
              hint: 'Role',
              onChanged: (value) {
                setState(() {
                  summary.role = value;
                });
              },
            ),
            ExpandedSection(
              child: Column(
                children: [
                  _buildLevel(context, summary.levels, 'role-$index'),
                  AddButton(
                    isButtonText: true,
                    textButton: 'ADD LEVEL',
                    onPressed: () {
                      setState(() {
                        summary.levels.add(Levels(levelName: '', technicals: []));
                      });
                    },
                  ),
                ],
              ),
              expand: summary.isExpand,
            ),


          ],
        ));
  }

  Widget _buildLevel(
      BuildContext context, List<Levels> levelDataList, String roleId) {
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

  Widget _buildLevelItem(BuildContext context, List<Levels> levelDataList,
      Levels levelData, int index, String roleId) {
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
          _buildTechnical(
              context, levelData.technicals, 'level-$index-$roleId', index)
        ],
      ),
    );
  }

  Widget _buildTechnical(BuildContext context, List<Technicals> technicalList,
      String levelId, int index) {
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
              technicalList.add(Technicals(summaryList: [], technicalName: ''));
            });
          },
        )
      ],
    );
  }

  Widget _buildTechnicalItem(
      BuildContext context,
      List<Technicals> technicalList,
      Technicals technicals,
      int index,
      String levelId) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blueGrey.shade100),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.military_tech_rounded,
                    color: Color(0xff434b65),
                  ),
                  Text(
                    'Technicals',
                    style: CommonStyle.size16W400hintTitle(context)
                        .copyWith(fontSize: 16),
                  )
                ],
              ),
              Spacer(),
              IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      technicalList.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Colors.red,
                  ))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFieldCommon(
                  controller: _generateController(
                      'technical-$index-$levelId', technicals.technicalName),
                  onChanged: (val) {
                    setState(() {
                      technicalList[index].technicalName = val;
                    });
                  },
                ),
              ),
            ],
          ),
          _buildListSummary(
            context,
            technicals.summaryList,
            'technical-$index-$levelId',
          )
        ],
      ),
    );
  }

  Widget _buildListSummary(
      BuildContext context, List<String> summaryList, String technicalId) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.post_add_rounded,
                color: Color(0xff434b65),
              ),
              Text(
                'Summary',
                style: CommonStyle.size16W400hintTitle(context)
                    .copyWith(fontSize: 16),
              )
            ],
          ),
        ),
        Column(
            children: List.generate(
                summaryList.length,
                (index) => _buildSummaryItem(context, technicalId,
                    summaryList[index], index, summaryList))),
        AddButton(
          isButtonText: true,
          textButton: 'ADD SUMMARY',
          onPressed: () {
            setState(() {
              summaryList.add('');
            });
          },
        )
      ],
    );
  }

  Widget _buildSummaryItem(BuildContext context, String summaryId, String value, int index, List<String> summaryList) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFieldCommon(
                  controller:
                      _generateController('summary-$index-$summaryId', value),
                  onChanged: (val) {
                    setState(() {
                      summaryList[index] = val;
                    });
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      summaryList.removeAt(index);
                    });
                  },
                  icon: Icon(Icons.close))
            ],
          ),
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
    TextSelection previousSelection = controller.selection;
    controller.text = value;
    controller.selection = previousSelection;
    _technicalController[key] = controller;
    return controller;
  }
}
