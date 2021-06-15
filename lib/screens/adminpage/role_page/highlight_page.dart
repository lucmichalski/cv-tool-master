import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';

class HighlightPage extends StatefulWidget {
  final MasterData masterData;
  const HighlightPage({this.masterData});

  @override
  _HighlightPageState createState() => _HighlightPageState();
}

class _HighlightPageState extends State<HighlightPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Highlight'),
    );

  }
}
