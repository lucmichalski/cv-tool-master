import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/confirm_dialog.dart';
import 'package:flutter_cv_maker/common/dropdown_custom.dart';
import 'package:flutter_cv_maker/common/gender_pdf.dart';
import 'package:flutter_cv_maker/helper.dart';
import 'package:flutter_cv_maker/models/cv_model/master_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model_response.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'change_password_screen.dart';

class HomeScreen extends StatefulWidget {
  final String fullName;
  const HomeScreen({Key key, this.fullName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _pageIdx = 1;
  List<CVModel> _cvList = [];
  List<int> _arrayIndexPageView = [];
  int touchedIndex = -1;
  bool _isHover = false;
  final _key = GlobalKey();
  CVModel _model;
  List<String> _menuList = [
    'Admin page',
    'Account',
    'Logout',
  ];
  List<DataPosition> _dataPosition = [];
  MasterData _masterData;
  int _pageIndex = 1;
  final _random = Random();
  bool _isStatusFiltered;
  bool _isDateFiltered = true;
  bool _isLoading = false;
  int _totalPage = 1;
  int _totalRecords = 0;
  int _totalDraft = 0;
  int _totalCompleted = 0;
  List<PaginationModel> _pageIndexList = [];
  bool _isLastSelected = false;
  AnimationController rotationController;
  String _userNm = '';
  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: _totalDraft.toDouble() ,
            title: '$_totalDraft',
            radius: radius,
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color:  Colors.green,
            value:_totalCompleted.toDouble(),
            title: '$_totalCompleted',
            radius: radius,
            badgePositionPercentageOffset: .98,
          );
        default:
          throw 'Oh no';
      }
    });
  }
  List<Legend> _legends = [
    Legend(
        color: Colors.amber,
        backgroundColor: Colors.amberAccent),
    Legend(
        color: Colors.red,
        backgroundColor: Colors.redAccent),
    Legend(
        color: Colors.green,
        backgroundColor: Colors.greenAccent),
    Legend(
        color: Colors.purple,
        backgroundColor: Colors.purpleAccent),
    Legend(
        color: Colors.indigo,
        backgroundColor: Colors.indigoAccent),
    Legend(
        color: Colors.purple,
        backgroundColor: Colors.purpleAccent),
    Legend(
        color: Colors.lime,
        backgroundColor: Colors.limeAccent),
    Legend(
        color: Colors.green,
        backgroundColor: Colors.greenAccent),
    Legend(
        color: Colors.blue,
        backgroundColor: Colors.blueAccent),
    Legend(
        color: Colors.teal,
        backgroundColor: Colors.tealAccent),
    Legend(
        color: Colors.cyan,
        backgroundColor: Colors.cyanAccent),
    Legend(
        color: Colors.deepPurple,
        backgroundColor: Colors.deepPurpleAccent),
  ];

  bool _isChangeCurrent;

  bool _isChangeNew;
  AnimationController _animationController;
  @override
  void initState() {
    _getUserNm();
    _fetchMasterData();
    // Get list cv
    _fetchCVList(_pageIdx);
    _animationController = AnimationController(vsync: this,
    lowerBound: 0.5,
    duration: Duration(seconds: 3))..repeat();
    _isChangeCurrent = true;
    _isChangeNew = true;
    _pageIndexList.add(PaginationModel(index: 1, isSelected: true));
    _fetchDataPosition();
    super.initState();
  }

  // Get username
  _getUserNm() async {
    final pref = await SharedPreferencesService.instance;
    _userNm = pref.getUserNm;
  }

  // Fetch master data to create/edit cv
  _fetchMasterData() async {
    BlocProvider.of<CVBloc>(context).add(RequestGetCVListEvent());
  }

  _fetchDataPosition() async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<CVBloc>(context)
        .add(RequestGetDataPositionEvent(pref.getAccessToken));
  }

  _fetchCVList(int index) async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<CVBloc>(context).add(RequestGetCVModel(
        pref.getAccessToken, index, _isStatusFiltered, _isDateFiltered));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CVBloc, CVState>(
        builder: (context, state) => _buildHomePage(context),
        listener: (context, state) {
          if (state is CVListLoading) {
            _isLoading = true;
          } else if (state is GetMasterDataSuccess) {
            _isLoading = false;
            setState(() {
              _masterData = state.masterData;
            });
          } else if (state is GetMasterDataError) {
            print('GetMasterDataError: ${state.message}');
            _isLoading = false;
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          } else if (state is GetCvListSuccess) {
            _totalRecords = state.cvList.total;
            _totalCompleted = state.cvList.totalCompleted;
            _totalDraft = state.cvList.totalDraft;
            _totalPage = state.cvList.totalPages;
            _isLoading = false;
            _model = state.cvList.recentCvModel;
            _cvList = state.cvList.items;
            _fetchDataPosition();
            if (_pageIndexList.isNotEmpty) {
              _pageIndexList.clear();
              if (_totalPage > 1) {
                for (int i = 1; i <= state.cvList.totalPages; i++) {
                  print(i);
                  // if (!_pageIndexList.contains(PaginationModel(index: i, isSelected: false))) {
                  _pageIndexList.add(PaginationModel(
                      index: i, isSelected: i == 1 ? true : false));
                  // }
                }
              } else {
                _pageIndexList.add(PaginationModel(index: 1, isSelected: true));
              }
            }
          } else if (state is GetCvListError) {
            print('GetCvListError: ${state.message}');
            _isLoading = false;
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          } else if (state is DeleteCvSuccess) {
            _isLoading = false;
            _fetchCVList(1);
            _fetchDataPosition();
          } else if (state is DeleteCvError) {
            _isLoading = false;
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          } else if (state is GetDataPositionSuccess) {
            _isLoading = false;
            _dataPosition = state.dataPosition;
          } else if (state is GetDataPositionError) {
            _isLoading = false;
            print('get data not error');
          } else if (state is UpdateCvSuccess) {
            _isLoading = false;
            _fetchDataPosition();
          } else if (state is CreateCvSuccess) {
            _isLoading = false;
            _fetchCVList(1);
          }
        },
        buildWhen: (context, state) =>
            state is GetMasterDataSuccess ||
            state is GetCvListSuccess ||
            state is GetDataPositionSuccess ||
            state is CreateCvSuccess);
  }

  Widget _buildHomePage(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 7,
                child: Column(
                  children: [
                    _buildMainPageHeader(context),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: w * 0.05),
                        child: _buildListCV(context),
                      ),
                    )
                  ],
                )),
            Expanded(
              flex: 3,
              child: _buildSecondaryPage(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryPage(BuildContext context) {
    List<int> draft = [];
    List<int> complete = [];
    for (int i = 0; i < _cvList.length; i++) {
      if (_cvList[i].status == false) {
        draft.add(i);
      } else {
        complete.add(i);
      }
    }
    var w = MediaQuery.of(context).size.width;
    return Container(
        color: Color(0xFF000034),
        // padding: EdgeInsets.only(top: w * 0.05),F'F
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: w * 0.01),
                  child: CustomDropdown<int>(
                    child: _buildTopMenu(context),
                    onChange: (int value, int index) =>
                        _handleDropdownTopUp(context, _menuList[index]),
                    dropdownButtonStyle: DropdownButtonStyle(
                      elevation: 1,
                      // backgroundColor: Colors.white,
                    ),
                    dropdownStyle: DropdownStyle(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 6,
                    ),
                    items: _menuList
                        .asMap()
                        .entries
                        .map(
                          (item) => DropdownItem<int>(
                            value: item.key + 1,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: item.key == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8))
                                      : item.key + 1 == _menuList.length
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8))
                                          : BorderRadius.all(
                                              Radius.circular(0)),
                                  color: Color(0xff2c3a5c).withOpacity(0.8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Text(
                                  item.value,
                                  style: CommonStyle.white700Size22(context)
                                      .copyWith(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                )),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: w,
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40))),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${ddMMMyyyy(DateTime.now())}',
                        style: CommonStyle.size12W400black(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(height: 1, color: Colors.grey),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.3,
                              child: Card(
                                color: Colors.white,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                          setState(() {
                                            final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                                pieTouchResponse.touchInput is! PointerUpEvent;
                                            if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                              touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                                            } else {
                                              touchedIndex = -1;
                                            }
                                          });
                                        }),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 0,
                                        sections: showingSections()),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 24),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      width: 60,
                                      height: 20,
                                    ),
                                    SizedBox(width: 10,),
                                    Text('Completed',style: CommonStyle.size10W700black(context).copyWith(fontSize: 12),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 24),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff8b250),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    width: 60,
                                    height: 20,
                                  ),
                                  SizedBox(width: 10,),
                                  Text('Draft',style: CommonStyle.size10W700black(context).copyWith(fontSize: 12))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Column(
                    //       children: [
                    //         Icon(Icons.summarize, color: Colors.pink),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //         Text.rich(TextSpan(children: [
                    //           TextSpan(
                    //               text: '$_totalRecords ',
                    //               style:
                    //                   CommonStyle.size16W400hintTitle(context)
                    //                       .copyWith(
                    //                           fontWeight: FontWeight.w700)),
                    //           TextSpan(
                    //               text: 'Total',
                    //               style: CommonStyle.grey400Size22(context)
                    //                   .copyWith(fontSize: 10)),
                    //         ]))
                    //       ],
                    //     )),
                    //     Expanded(
                    //         child: Column(
                    //       children: [
                    //         Icon(
                    //           Icons.timelapse,
                    //           color: Colors.amber,
                    //         ),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //         Text.rich(TextSpan(children: [
                    //           TextSpan(
                    //               text: '$_totalDraft ',
                    //               style:
                    //                   CommonStyle.size16W400hintTitle(context)
                    //                       .copyWith(
                    //                           fontWeight: FontWeight.w700)),
                    //           TextSpan(
                    //               text: 'Draft',
                    //               style: CommonStyle.grey400Size22(context)
                    //                   .copyWith(fontSize: 10)),
                    //         ]))
                    //       ],
                    //     )),
                    //     Expanded(
                    //         child: Column(
                    //       children: [
                    //         Icon(Icons.check_circle, color: Colors.greenAccent),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //         Text.rich(TextSpan(children: [
                    //           TextSpan(
                    //               text: '$_totalCompleted ',
                    //               style:
                    //                   CommonStyle.size16W400hintTitle(context)
                    //                       .copyWith(
                    //                           fontWeight: FontWeight.w700)),
                    //           TextSpan(
                    //               text: 'Completed',
                    //               style: CommonStyle.grey400Size22(context)
                    //                   .copyWith(fontSize: 10)),
                    //         ]))
                    //       ],
                    //     )),
                    //   ],
                    // ),
                    SizedBox(
                      height: 26,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Categories', style: CommonStyle.size12W400black(context),),
                    ),
                    _dataPosition != null && _dataPosition.isNotEmpty
                        ? SingleChildScrollView(
                          child: Wrap(
                              runAlignment: WrapAlignment.spaceAround,
                              spacing: 16,
                              runSpacing: 16,
                              children: List.generate(
                                  _dataPosition.length,
                                  (index) => _buildLegendItem(
                                      context, _dataPosition[index], index)),
                            ),
                        )
                        : Text('No item available')
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // Create chart

  Widget _buildMainPageHeader(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            decoration: BoxDecoration(
                color: Color(0xFF000034),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                )),
            child: Container(
                padding: EdgeInsets.all(26.0),
                margin: EdgeInsets.only(left: w * 0.058, right: w * 0.058),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CV Tool',
                      style: CommonStyle.size48W700White(context),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color(0xff111242)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                FilterCustom(
                                  onclick: () {
                                    setState(() {
                                      _isStatusFiltered = null;
                                      _isDateFiltered = null;
                                      _fetchCVList(1);
                                    });
                                  },
                                  text: 'All',
                                  sizeBorder: true,
                                ),
                                FilterCustom(
                                  onclick: () {
                                    setState(() {
                                      if (_isStatusFiltered == null) {
                                        _isStatusFiltered = false;
                                      } else {
                                        _isStatusFiltered = !_isStatusFiltered;
                                      }
                                      _fetchCVList(1);
                                    });
                                  },
                                  text: _isStatusFiltered == null
                                      ? 'Status'
                                      : _isStatusFiltered
                                          ? 'Completed'
                                          : 'Draft',
                                  sizeBorder: true,
                                ),
                                FilterCustom(
                                  onclick: () {
                                    setState(() {
                                      if (_isDateFiltered == null) {
                                        _isDateFiltered = false;
                                      } else {
                                        _isDateFiltered = !_isDateFiltered;
                                      }
                                      _fetchCVList(1);
                                    });
                                  },
                                  text: 'Created Date',
                                  sizeBorder: true,
                                  isDesc: _isDateFiltered,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        _buildAnimation(),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Recent Add',
                        style: CommonStyle.size48W700White(context)
                            .copyWith(fontSize: 18),
                      ),
                    )
                  ],
                )),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 4.3,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width / 1.8,
                height: 100,
                child: _model != null
                    ? _buildCVItem(context, _model, true, 1)
                    : Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Text('No item available'),
                      ),
                // _buildCVItem(context, _cvList[0])
              ))
        ],
      ),
    );
  }

  _buildAnimation() {
    return AnimatedBuilder(
        animation: CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn),
        builder: (context, child) {
          return _buildContainer(context, 100 * _animationController.value, ButtonCommon(
            buttonText: 'NEW CV',
            onClick: () {
              _handleCreateCVEvent();
            },
            color: Color(0xff5ace9f),
            prefixIcon: Icon(Icons.insert_drive_file_rounded,
                color: Colors.white),
            borderRadius: 20,
            prefixDrawablePadding: 8,
          ),);
        });
  }

  _buildContainer(BuildContext context, double radius, Widget child) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey.withOpacity(1 - _animationController.value),
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: child,
    );
  }

  _getSize() async {
    if (_key.currentContext != null) {
      final _size = _key.currentContext.size;
      final _width = _size.width;
      final _height = _size.height;
      ('Width: $_width -- Height: $_height');
    }
  }

  // Handle onClick create CV event
  _handleCreateCVEvent() {
    CVModel model = CVModel(
        name: '',
        email: '',
        position: '',
        highLightProjectList: [
          HighLightProjectList(
              projectNm: '',
              responsibility: [],
              technologies: [],
              position: '',
              teamSize: '',
              projectDescription: '',
              communicationused: '',
              documentcontrol: '',
              projectmanagementtool: '',
              uiuxdesign: '')
        ],
        technicalSummaryList: [],
        status: false,
        educationList: [],
        skills: [],
        professionalList: [],
        certificateList: [],
        gender: 'Mr.');

    navKey.currentState.pushNamed(routeCreateCV, arguments: model);
  }

  // Create list CV
  Widget _buildListCV(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 5,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.078),
          child: _buildPaginationLayouts(context),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: w * 0.078),
        //   child: _buildPaginationLayout(context),
        // ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.078),
          child: Divider(
            height: 1,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.078),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CV List',
                style: CommonStyle.size14W700black(context),
              ),
            ],
          ),
        ),
        _isLoading
            ? Container(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: _cvList.length > 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(top: 30),
                          shrinkWrap: true,
                          itemCount: _cvList.length,
                          itemBuilder: (context, index) {
                            final item = _cvList[index];
                            return _buildCVItem(context, item, false, index);
                          })
                      : Container(
                          child: Text('No CV available',
                              style: CommonStyle.grey900Size48(context)
                                  .copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400)),
                        ),
                ),
              ),
      ],
    );
  }

  // Build item CV
  Widget _buildCVItem(
      BuildContext context, CVModel model, bool isRecent, int index) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: !isRecent ? w * 0.01 : 0,
          horizontal: !isRecent ? w * 0.074 : 0),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap: () {
            var professionalExp;
            if (model.professionalList != null && model.professionalList.isNotEmpty) {
              professionalExp = model.professionalList
                  .firstWhere(
                      (element) =>
                  element.roleNm.isEmpty ||
                      element.companyNm.isEmpty ||
                      element.locationNm.isEmpty ||
                      element.responsibilities.isEmpty,
                  orElse: () => null);
            }
            var projectHighlight;
            if (model.highLightProjectList != null && model.highLightProjectList.isNotEmpty) {
              projectHighlight = model.highLightProjectList
                  .firstWhere(
                      (element) =>
                  element.projectNm.isEmpty ||
                      element.position.isEmpty ||
                      element.technologies.isEmpty ||
                      element.responsibility.isEmpty ||
                      element.teamSize.isEmpty ||
                      element.projectDescription.isEmpty,
                  orElse: () => null);
            }

           if(model.name.isNotEmpty ||
               model.position.isNotEmpty ||
               model.email.isNotEmpty ||
               model.technicalSummaryList.isNotEmpty){
             _arrayIndexPageView.add(1);
           }

           if(professionalExp == null ){
             _arrayIndexPageView.add(3);
           }
           if(projectHighlight== null){
             _arrayIndexPageView.add(4);
           }
           if(model.educationList.isEmpty){
             _arrayIndexPageView.add(2);
           }
            navKey.currentState.pushNamed(routeCreateCV, arguments:model);
          },
            
          child: Container(
              decoration: BoxDecoration(),
              height: 100,
              // padding: EdgeInsets.symmetric(vertical: w * 0.01),
              child: Row(
                children: [
                  // Date time
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.087,
                            width: 3.5,
                            decoration: BoxDecoration(
                                color: model.status
                                    ? Colors.lightGreen
                                    : Colors.amber,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(50.0))),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${getDateStr(model.strCreatedDate, DateType.date)}',
                                  style: CommonStyle.size10xam(context)),
                              Text('${getDateStr(model.strCreatedDate, DateType.time)}',
                                  style: CommonStyle.size12W400xam(context)),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.005),
                    child: VerticalDivider(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  // Name & position
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${model.name}',
                            style: CommonStyle.size12W400xam(context),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.work,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('${model.position}',
                                  style: CommonStyle.size10xam(context))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // Email & status
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${model.email}',
                          style: CommonStyle.size12W400xam(context),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: (model.status ?? Colors.amber)
                                  ? Colors.green
                                  : Colors.amber,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${(model.status ?? false) ? 'Completed' : 'Draft'}',
                              style: CommonStyle.size10xam(context).copyWith(
                                  fontSize: 12,
                                  color: (model.status ?? Colors.amber)
                                      ? Colors.green
                                      : Colors.amber),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Actions
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        IconButton(
                            tooltip: 'Download',
                            color: Color(0xff434b65),
                            icon: Icon(Icons.download_rounded),
                            onPressed: () async {
                              downloadPdf(context, model);
                            }),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return ConfirmDialog(
                                    onDeleteConfirmed: () async {
                                      final pref =
                                          await SharedPreferencesService
                                              .instance;
                                      BlocProvider.of<CVBloc>(context).add(
                                          RequestDeleteCvEvent(
                                              pref.getAccessToken,
                                              _cvList[index].id));
                                    },
                                  );
                                });
                          },
                          tooltip: 'Delete',
                          color: Color(0xff434b65),
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildTopMenu(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.lightBlue, width: 2)),
              child: CircleAvatar(
                child: Icon(Icons.person),
              )),
          SizedBox(
            width: 10,
          ),
          MouseRegion(
            onHover: (val) => setState(() => _isHover = true),
            onExit: (val) => setState(() => _isHover = false),
            child: Text('$_userNm', style: CommonStyle.main700Size18(context).copyWith(
                color: Colors.white,
                decoration: _isHover
                    ? TextDecoration.underline
                    : TextDecoration.none),),
          ),
          SizedBox(
            width: w * 0.05,
          )
        ],
      ),
    );
  }

  Widget _buildPaginationLayouts(BuildContext context){

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1,color:Colors.grey)
        ),
            // padding: EdgeInsets.symmetric(vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.21),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: IconButton(onPressed: (){
          setState(() {
                _pageIdx--;
                if(_pageIdx <1){
                  _pageIdx =1;
                }
                _fetchCVList(_pageIdx);
          });
                }, icon: Icon(Icons.chevron_left,size: 30,color: Colors.redAccent,),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor:Colors.transparent ,
                ),
              ),
            ),
            VerticalDivider(width: 1,color: Colors.grey,),
            Expanded(
              child: Text(
                '${_pageIdx < _pageIndexList.length ? _pageIdx : _pageIndexList
                    .length } of ${_pageIndexList.length}',
                textAlign: TextAlign.center,
                style: CommonStyle.size16W400hintTitle(context),),
            ),
            VerticalDivider(width: 1,color: Colors.grey,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: IconButton(onPressed: (){
                  setState(() {
                    _pageIdx++;
                    if(_pageIdx > _pageIndexList.length){
                      _pageIdx = _pageIndexList.length;
                    }
                    _fetchCVList(_pageIdx);
                  });
                }, icon: Icon(Icons.chevron_right,size: 30,color: Colors.redAccent,),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor:Colors.transparent ,),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildPaginationLayout(BuildContext context) {
    if (_totalPage == null || _totalPage == 0) return Container();
    print(' total page :$_totalPage');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: _totalPage > 1 && !_pageIndexList[0].isSelected,
          child: TextButton(
              onPressed: () {
                setState(() {
                  _isLastSelected = false;
                  _pageIndexList.forEach((element) {
                    element.isSelected = false;
                  });
                  _pageIndexList[0].isSelected = true;
                  _fetchCVList(1);
                });
              },
              child: Text('PREV')),
        ),
        Row(
          children: _pageIndexList.take(3)
              .map((e) => InkWell(
                    onTap: () {
                      setState(() {
                        _isLastSelected = false;
                        _pageIndexList.forEach((element) {
                          element.isSelected = false;
                        });
                        e.isSelected = true;
                        _fetchCVList(e.index);
                      });
                    },
                    child: Container(
                      color: e.isSelected ? Colors.blue : Colors.transparent,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text(
                          '${e.index}',
                          style: TextStyle(
                              color: e.isSelected ? Colors.white : Colors.blue,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        Visibility(
          visible: _totalPage > 4,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              '...',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ),
        Visibility(
          visible: _totalPage > 4,
          child: InkWell(
            onTap: () {
              setState(() {
                _pageIndexList.forEach((element) {
                  element.isSelected = false;
                });
                _isLastSelected = true;
              });
              _fetchCVList(_totalPage);
            },
            child: Container(
              color: _isLastSelected ? Colors.blue : Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Text(
                  '$_totalPage',
                  style: TextStyle(
                      color: _isLastSelected ? Colors.white : Colors.blue,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _totalPage > 4,
          child: TextButton(
              onPressed: () {
                setState(() {
                  _isLastSelected = true;
                });
                _fetchCVList(_totalPage);
              },
              child: Text('NEXT')),
        ),
      ],
    );
  }

  // Handle events for dropdown
  _handleDropdownTopUp(BuildContext context, String value) {
    switch (value) {
      case 'Logout':
        _handleSignOut(context);
        break;
      case 'Admin page':
        _handleAdminPage(context);
        break;
      case 'Account':
        _handleAccountPage(context);
        break;
    }
  }

  // Process handle event for Sign out
  _handleSignOut(BuildContext context) async {
    final pref = await SharedPreferencesService.instance;
    pref.removeAccessToken();
    pref.removeUserNm();
    navKey.currentState.pushNamedAndRemoveUntil(routeLogin, (route) => false);
  }

  // Process handle event for transition to Admin page
  _handleAdminPage(BuildContext context) {
    navKey.currentState.pushNamed(
      routeAdmin,
    );
  }

  // Process handle event for transition to Account page
  _handleAccountPage(BuildContext context) {
    navKey.currentState.pushNamed(
      routeChangePass,
    );
  }

  // Display legend categories
  Widget _buildLegendItem(BuildContext context, DataPosition data, int index) {
    double total = (data.total /_totalRecords) > 1.0 ? 0.0 : (data.total /_totalRecords);
    double percentTxt = double.tryParse((total * 100).toStringAsFixed(2));
    var w = MediaQuery.of(context).size.width;

    return MouseRegion(
      onHover: (val) {
        setState(() {
          _dataPosition.forEach((element) {
            element.isHover = false;
          });
          data.isHover = true;
        });
      },
      onExit: (val) {
        setState(() {
         data.isHover = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: w * 0.1,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: data.isHover ? _legends[index].color : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data.position}',
              style: GoogleFonts.roboto(
                  color: data.isHover ? Colors.white : _legends[index].color,
                  fontSize: 12),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 6.0,
                  percent: total,
                  center: Text(
                    '$percentTxt%',style: GoogleFonts.roboto(fontSize: 9, fontWeight: FontWeight.w700, color: data.isHover ? Colors.white : _legends[index].color),
                  ),
                  backgroundColor:data.isHover ? _legends[index].backgroundColor : Colors.grey.shade50,
                  progressColor: data.isHover ? Colors.white : _legends[index].color,
                ),
                Spacer(),
                Text.rich(TextSpan(children: [
                  TextSpan(text: 'Total: ', style: GoogleFonts.roboto(color: data.isHover ? Colors.white : _legends[index].color, fontSize: 10,)),
                  TextSpan(
                    text:
                        '${data.total}',
                    style: CommonStyle.size10W700black(context).copyWith(color: data.isHover ? Colors.white : _legends[index].color)
                  ),
                ]))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaginationModel {
  int index;
  bool isSelected;

  PaginationModel({this.index, this.isSelected});
}

class Legend {
  Color color;
  Color backgroundColor;

  Legend(
      {
      this.color,
      this.backgroundColor});
}
class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
      this.svgAsset, {
        this.size,
        this.borderColor,
      }) ;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .15),
      child:Text(''),
    );
  }
}