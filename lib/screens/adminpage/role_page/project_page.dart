import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';

class ProjectPage extends StatefulWidget {
  final MasterData masterData;
  final Function onPrevious;

  const ProjectPage({this.masterData, this.onPrevious});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Map<String, TextEditingController> _technicalController = {};

  @override
  void initState() {
    // if (widget.masterData.projectMaster == null || widget.masterData.projectMaster.isEmpty)
    //   widget.masterData.projectMaster.add(ProjectMaster(role: '', responsibilities: ['']));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            _buildProjectList(context),
            AddButton(
              isButtonText: true,
              textButton: 'ADD PROJECT RESPONSIBILITY',
              onPressed: () {
                setState(() {
                  widget.masterData.projectMaster
                      .add(ProjectMaster(role: '', responsibilities: ['']));
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(BuildContext context) {
    return Column(
      children: widget.masterData.projectMaster
          .map((e) => _buildProjectItem(
              context, e, widget.masterData.projectMaster.indexOf(e)))
          .toList(),
    );
  }

  Widget _buildProjectItem(
      BuildContext context, ProjectMaster company, int index) {
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
                      widget.masterData.projectMaster.removeAt(index);
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
              label: 'Project Role',
              onChanged: (value) {
                setState(() {
                  widget.masterData.projectMaster[index].role = value;
                });
              },
              controller: _generateController(
                'project-$index',
                company.role,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.work,
                    color: Color(0xff434b65),
                  ),
                  Text(
                    'Project Responsibilities',
                    style: CommonStyle.size16W400hintTitle(context)
                        .copyWith(fontSize: 16),
                  )
                ],
              ),
            ),
            buildResponsibilities(
                context,
                widget.masterData.projectMaster[index].responsibilities,
                'company-$index'),
            AddButton(
              isButtonText: true,
              textButton: 'ADD RESPONSIBILITY',
              onPressed: () => setState(() => widget
                  .masterData.projectMaster[index].responsibilities
                  .add('')),
            )
          ],
        ));
  }

  Widget buildResponsibilities(BuildContext context,
      List<String> responsibilities, String roleCompanyValue) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Color(0xFFedf4ff),
          border: Border.all(color: Color(0xffccdfff), width: 1)),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Column(
              children: List.generate(
                  responsibilities.length,
                  (index) => _buildResponsibilityItem(context, responsibilities,
                      responsibilities[index], index, roleCompanyValue))),
        ],
      ),
    );
  }

  Widget _buildResponsibilityItem(
      BuildContext context,
      List<String> responsibilities,
      String responsibility,
      int index,
      String companyId) {
    print('responsibility-$index-$companyId');
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCommon(
              label: kEmpty,
              controller: _generateController(
                  'responsibility-$index-$companyId', responsibility),
              onChanged: (val) {
                setState(() {
                  responsibilities[index] = val;
                });
              },
            ),
          ),
          IconButton(
              hoverColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  responsibilities.removeAt(index);
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
    TextSelection previousSelection = controller.selection;
    controller.text = value;
    controller.selection = previousSelection;
    _technicalController[key] = controller;
    return controller;
  }
}
