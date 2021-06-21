import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/master_bloc.dart';
import 'package:flutter_cv_maker/common/TabModels.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_%20five_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_four_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_one_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_second_screen.dart';
import 'package:flutter_cv_maker/screens/viewPageCreateCv/section_three_screen.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

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
  MasterData masterData;

  // Page index
  int _pageIndex = 0;

  _addItemsSteps() {
    _tab.add(TabModelSteps(
        numberPage: 0,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_I,
        step: 'Step 1'));
    _tab.add(TabModelSteps(
        numberPage: 1,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_II,
        step: 'Step 2'));
    _tab.add(TabModelSteps(
        numberPage: 2,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_III,
        step: 'Step 3'));
    _tab.add(TabModelSteps(
        numberPage: 3,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_IV,
        step: 'Step 4'));
    _tab.add(TabModelSteps(
        numberPage: 4,
        horizontalLine: true,
        colorIcons: false,
        title: SECTION_V,
        step: 'Step 5'));
  }

  _onPageViewChange(int index) {
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
    _fetchMasterData();
    if (widget.cvModel == null) {
      _cvModel = CVModel(
          name: '',
          email: '',
          position: '',
          technicalSummaryList: [],
          status: false,
          gender: 'Male');
    } else {
      _cvModel = widget.cvModel;
    }
    _addItemsSteps();
    super.initState();
  }

  // Fetch master data to create/edit cv
  _fetchMasterData() async {
    BlocProvider.of<CVBloc>(context).add(RequestGetCVListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CVBloc, CVState>(
      builder: (context, state) => _buildUI(context),
      listener: (context, state) {
        if (state is CVListLoading) {
          showProgressBar(context, true);
        } else if (state is GetCVListSuccess) {
          showProgressBar(context, false);
          setState(() {
            masterData = state.masterData;
          });
          print('MasterData: ${masterData.summary.first.role}');
        } else if (state is GetCVListError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is CreateCvSuccess) {
          showProgressBar(context, false);
          print('create cv success');
        } else if (state is CreateCvError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        }
      },
      buildWhen: (context, state) => state is GetCVListSuccess,
    );
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(child: _buildPageSteps(context)),
            SizedBox(
              height: 50.0,
            ),
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
                    masterData: masterData,
                  ),
                  SecondScreen(
                    pageController: _pageController,
                    cvModel: _cvModel,
                    masterData: masterData,
                  ),
                  SectionThree(
                    pageController: _pageController,
                    cvModel: _cvModel,
                    initialDate: DateTime.now(),
                  ),
                  SectionFour(
                    cvModel: _cvModel,
                    pageController: _pageController,
                    masterData: masterData,
                  ),
                  SectionFive(
                    cvModel: _cvModel,
                    saveSv: () async {
                      final pref = await SharedPreferencesService.instance;
                      String requestBody = json.encoder.convert(_cvModel);
                      print(requestBody);
                      BlocProvider.of<CVBloc>(context).add(RequestCreateCvEvent(
                          pref.getAccessToken, requestBody));
                    },
                    pageController: _pageController,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modelSteps.step,
                  style: TextStyle(
                      color: index == _pageIndex
                          ? kmainColor
                          : Colors.grey,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  modelSteps.title,
                  style: TextStyle(
                      color:Colors.grey,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          modelSteps.horizontalLine == true
              ? Container(
                  width: MediaQuery.of(context).size.width / 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tab[index].title != SECTION_V
                          ? Divider(
                              color: modelSteps.colorIcons
                                  ? Colors.greenAccent.shade400
                                  : Colors.black26)
                          : Container(),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
