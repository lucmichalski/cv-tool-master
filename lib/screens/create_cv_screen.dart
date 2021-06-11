import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/TabModels.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/screens/viewPageCreatecv/section_one_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreatecv/section_second_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreatecv/section_three_screen.dart';

import '../common/common_style.dart';

class CreateCV extends StatefulWidget {
  final CVModel cvModel;

  const CreateCV({this.cvModel});

  @override
  _CreateCVState createState() => _CreateCVState();
}

class _CreateCVState extends State<CreateCV> {
  final PageController controller = PageController(initialPage: 0);
  final PageController _pageController = PageController();
  List<TabModelSteps> _tab = [];
  CVModel _cvModel;

  // Page index
  int _pageIndex = 0;

  _addItemsSteps() {
    _tab.add(
        TabModelSteps(numberPage: 0, horizontalLine: false, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 1, horizontalLine: true, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 2, horizontalLine: true, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 3, horizontalLine: true, colorIcons: false));
    _tab.add(
        TabModelSteps(numberPage: 4, horizontalLine: true, colorIcons: false));
  }

  _onPageViewChange(int index) {
    print("Current Page: " + index.toString());
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
    _pageController.dispose();
    super.dispose();
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
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: _buildPageSteps(context)),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                _getPageName(),
                style: CommonStyle.size48W700black(context),
                textAlign: TextAlign.center,
              ),
            ),
            // nó cứ vào cái giao diện call vs anh. không , ý em là nó k cho search ấy
            Expanded(
              child: PageView(
                // physics:new NeverScrollableScrollPhysics(),
                onPageChanged: _onPageViewChange,
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: <Widget>[
                  SectionOneScreen(
                    cvModel: _cvModel,
                    pageController: _pageController,
                  ),
                  SecondScreen(
                    pageController: _pageController,
                    cvModel: _cvModel,
                  ),
                  SectionThree(
                    cvModel: _cvModel,
                    initialDate: DateTime.now(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          _tab.map((e) => _buildStepItem(context, e, _tab.indexOf(e))).toList(),
    );
  }

  Widget _buildStepItem(
      BuildContext context, TabModelSteps modelSteps, int index) {
    return Container(
      child: Row(
        children: [
          modelSteps.horizontalLine == true
              ? Container(
                  width: MediaQuery.of(context).size.width / 9,
                  child: Divider(
                      color: modelSteps.colorIcons
                          ? Colors.greenAccent.shade400
                          : Colors.black26),
                )
              : SizedBox(),
          Container(
            width: MediaQuery.of(context).size.width * 0.03,
            height: MediaQuery.of(context).size.width * 0.03,
            decoration: BoxDecoration(
              color: _pageIndex == modelSteps.numberPage
                  ? Colors.white
                  : modelSteps.colorIcons
                      ? Colors.greenAccent.shade400
                      : Colors.black26,
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
                style: CommonStyle.main700Size18(context).copyWith(
                  color: _pageIndex == modelSteps.numberPage
                      ? Colors.blue
                      : modelSteps.colorIcons
                          ? Colors.white
                          : Colors.black,
                )),
          ),
        ],
      ),
    );
  }
}
