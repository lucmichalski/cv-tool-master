import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
class SkillPage extends StatefulWidget {
  final MasterData masterData;
  const SkillPage({this.masterData});

  @override
  _SkillPageState createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('skill page'),
    );
  }
}
