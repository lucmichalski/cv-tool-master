import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/TabModels.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/screens/viewPageCreatecv/section_one_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreatecv/section_second_screen.dart';

class CreateCV extends StatefulWidget {
  final CVModel cvModel;

  const CreateCV({this.cvModel});

  @override
  _CreateCVState createState() => _CreateCVState();
}

class _CreateCVState extends State<CreateCV> {
  final PageController controller = PageController(initialPage: 0);
  List<TabModelSteps> _tab = [];
  CVModel _cvModel;

  // Page index
  int _pageIndex = 0;

  _addItemsSteps() {
    _tab.add(
        TabModelSteps(numberPage: 1, horizontalLine: true, colorIcons: true));
    _tab.add(
        TabModelSteps(numberPage: 2, horizontalLine: true, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 3, horizontalLine: true, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 4, horizontalLine: true, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 5, horizontalLine: false, colorIcons: false));
  }

  _onPageViewChange(int index) {
    print("Current Page: " + index.toString());
    setState(() {
      _pageIndex = index;
      _tab[index].colorIcons = true;
    });
  }

  @override
  void initState() {
    if (widget.cvModel == null) {
      _cvModel = CVModel(
          name: '',
          email: '',
          position: '',
          technicalSummaryList: [],
          status: false,
          gender: 1);
    } else {
      _cvModel = widget.cvModel;
    }
    _addItemsSteps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 7),
                width: MediaQuery.of(context).size.width,
                child: _buildPageSteps(context)),
            Container(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                _getPageName(),
                style: CommonStyle.size48W700black(context),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: _onPageViewChange,
                scrollDirection: Axis.horizontal,
                controller: controller,
                children: <Widget>[
                  SectionOneScreen(
                    cvModel: _cvModel,
                  ),
                  SecondScreen(),
                  Container(
                    color: Colors.blue.shade300,
                    child: Center(
                      child: Text('3rd Page'),
                    ),
                  ),
                  Container(
                    color: Colors.yellow.shade300,
                    child: Center(
                      child: Text('4th Page'),
                    ),
                  ),
                  Container(
                    color: Colors.purple.shade300,
                    child: Center(
                      child: Text('5th Page'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle page name
  String _getPageName() {
    switch (_pageIndex) {
      case 0:
        return SECTION_I;
        break;
      case 1:
        return SECTION_II;
        break;
      case 2:
        return SECTION_III;
        break;
      case 3:
        return SECTION_IV;
        break;
      case 4:
        return SECTION_V;
        break;
      default:
        return SECTION_I;
        break;
    }
  }

  Widget _buildPageSteps(BuildContext context) {
    return Row(
      children:
          _tab.map((e) => _buildStepItem(context, e, _tab.indexOf(e))).toList(),
    );
  }

  Widget _buildStepItem(
      BuildContext context, TabModelSteps modelSteps, int index) {
    return Container(
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 19,
            height: MediaQuery.of(context).size.width / 19,
            decoration: BoxDecoration(
              color: modelSteps.colorIcons ? Colors.lightGreen : Colors.black26,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: Text(modelSteps.numberPage.toString()),
          ),
          modelSteps.horizontalLine == true
              ? Container(
                  width: MediaQuery.of(context).size.width / 9,
                  child: Divider(color: Colors.black),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
