
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
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:universal_html/html.dart' as html;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin  {
  List<CVModel> _cvList = [];
  int touchedIndex = -1;
  List<String> _menuList = [
    'Admin page',
    'Account',
    'Logout',
  ];
  MasterData _masterData;
  int _pageIndex = 1;
  bool _isStatusFiltered;
  bool _isDateFiltered;
  bool _isLoading = false;
  int _totalPage = 1;
  int _totalRecords = 0;
  int _totalDraft = 0;
  int _totalCompleted = 0;
  List<PaginationModel> _pageIndexList = [];
  bool _isLastSelected = false;
  AnimationController rotationController;
  List<Legend> _legends = [
    Legend(title: 'Mobile Developer', percent: 0.15, value: '15%', color: Colors.amber, backgroundColor: Colors.amberAccent),
    Legend(title: 'Frontend Developer', percent: 0.15, value: '15%', color: Colors.red, backgroundColor: Colors.redAccent),
    Legend(title: 'Backend Developer', percent: 0.20, value: '20%', color: Colors.green, backgroundColor: Colors.greenAccent),
    Legend(title: 'Project Manager', percent: 0.40, value: '40%', color: Colors.purple, backgroundColor: Colors.purpleAccent),
    Legend(title: 'Golang', percent: 0.1, value: '10%', color: Colors.indigo, backgroundColor: Colors.indigoAccent),
  ];

  @override
  void initState() {
    // rotationController = AnimationController(vsync: this, duration: Duration(seconds: 5), upperBound: pi * 2);
    // rotationController.repeat();
    // Get master data
    _fetchMasterData();
    // Get list cv
    _fetchCVList(1);
    _pageIndexList.add(PaginationModel(index: 1, isSelected: true));
    super.initState();
  }

  // Fetch master data to create/edit cv
  _fetchMasterData() async {
    BlocProvider.of<CVBloc>(context).add(RequestGetCVListEvent());
  }

  _fetchCVList(int index) async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<CVBloc>(context).add(RequestGetCVModel(
        pref.getAccessToken, index, _isStatusFiltered, _isDateFiltered));
  }

  @override
  void dispose() {
    // receivePort.close();
    // isolate.kill();
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
          _isLoading = false;
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is GetCvListSuccess) {
          _totalRecords = state.cvList.total;
          _totalCompleted = state.cvList.totalCompleted;
          _totalDraft = state.cvList.totalDraft;
          _totalPage = state.cvList.totalPages;
          _isLoading = false;
          _cvList = state.cvList.items;
          if (_pageIndexList.isNotEmpty && _pageIndexList[0].isSelected) {
            _pageIndexList.clear();
            for (int i = 1; i <= state.cvList.totalPages; i++) {
              // if (!_pageIndexList.contains(PaginationModel(index: i, isSelected: false))) {
              _pageIndexList.add(
                  PaginationModel(index: i, isSelected: i == 1 ? true : false));
              // }
            }
          }
        } else if (state is GetCvListError) {
          _isLoading = false;
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is DeleteCvSuccess) {
          _isLoading = false;
          _fetchCVList(1);
        } else if (state is DeleteCvError) {
          _isLoading = false;
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        }
      },
      buildWhen: (context, state) =>
          state is GetMasterDataSuccess || state is GetCvListSuccess,
    );
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
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Icon(Icons.summarize, color: Colors.pink),
                            SizedBox(
                              height: 5,
                            ),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: '$_totalRecords ',
                                  style:
                                      CommonStyle.size16W400hintTitle(context)
                                          .copyWith(
                                              fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text: 'Total',
                                  style: CommonStyle.grey400Size22(context)
                                      .copyWith(fontSize: 10)),
                            ]))
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            Icon(
                              Icons.timelapse,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: '$_totalDraft ',
                                  style:
                                      CommonStyle.size16W400hintTitle(context)
                                          .copyWith(
                                              fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text: 'Draft',
                                  style: CommonStyle.grey400Size22(context)
                                      .copyWith(fontSize: 10)),
                            ]))
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.greenAccent),
                            SizedBox(
                              height: 5,
                            ),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: '$_totalCompleted ',
                                  style:
                                      CommonStyle.size16W400hintTitle(context)
                                          .copyWith(
                                              fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text: 'Completed',
                                  style: CommonStyle.grey400Size22(context)
                                      .copyWith(fontSize: 10)),
                            ]))
                          ],
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    //:TODO - Build chart
                    // _buildChart(context),
                    Wrap(
                      runAlignment: WrapAlignment.spaceAround,
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(_legends.length, (index) => _buildLegendItem(context, _legends[index])),
                    )
                    // RotationTransition(
                    //   turns: Tween(begin: 0.0, end: 1.0)
                    //       .animate(rotationController),
                    //   child: Icon(
                    //     Icons.home,
                    //     size: 40,
                    //   ),
                    // ),
                    // OutlinedButton(onPressed: () {
                    //   runForLoop();
                    // }, child: Text('Bấm vào em đi')),
                    // Text('$counter')
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // Create chart
  Widget _buildChart(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: PieChart(
          PieChartData(
              centerSpaceRadius: 1,
              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                setState(() {
                  final desiredTouch =
                      pieTouchResponse.touchInput is! PointerExitEvent &&
                          pieTouchResponse.touchInput is! PointerUpEvent;
                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                    touchedIndex =
                        pieTouchResponse.touchedSection.touchedSectionIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 16,
              sections: showingSections()),
          swapAnimationDuration: Duration(milliseconds: 150), // Optional
          swapAnimationCurve: Curves.linear),
    );
  }

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
                margin: EdgeInsets.only(left: w * 0.058),
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
                                // FilterCustom(
                                //   text: 'Role',
                                //   sizeBorder: true,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin:
                              EdgeInsets.only(right: w * 0.058, left: w * 0.02),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xff2c3a5c).withOpacity(0.8)),
                          child: ButtonCommon(
                            buttonText: 'NEW CV',
                            onClick: () {
                              _handleCreateCVEvent();
                            },
                            color: Color(0xff5ace9f),
                            prefixIcon: Icon(Icons.insert_drive_file_rounded,
                                color: Colors.white),
                            borderRadius: 20,
                            prefixDrawablePadding: 8,
                          ),
                        ),
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
                child: _buildCVItem(
                    context,
                    _cvList != null && _cvList.isNotEmpty
                        ? _cvList.elementAt(0)
                        : CVModel(
                            position: '', email: '', status: false, name: ''),
                    true,
                    1),
                // _buildCVItem(context, _cvList[0])
              ))
        ],
      ),
    );
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
          child: _buildPaginationLayout(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.078),
          child: Divider(
            height: 1,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 10,
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
                color: Colors.white,
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
          onTap: () =>
              navKey.currentState.pushNamed(routeCreateCV, arguments: model),
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
                              Text(
                                '${hhMM(model.createdDate)}',
                                style: CommonStyle.size12W400xam(context),
                              ),
                              Text('${getDate(model.createdDate)}',
                                  style: CommonStyle.size10xam(context))
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
                              // final url =
                              // html.Url.createObjectUrlFromBlob(await myGetBlobPdfContent());
                              // final anchor =
                              // html.document.createElement('a') as html.AnchorElement
                              // ..href = url
                              // ..style.display = 'none'
                              // ..download = 'CV_TVF_.pdf';
                              // //${widget.cvModel.name.replaceAll(' ', '_')}
                              // html.document.body.children.add(anchor);
                              // anchor.click();
                              // html.document.body.children.remove(anchor);
                              // html.Url.revokeObjectUrl(url);
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
            width: 16,
          ),
          LinkText(text: 'Kelvin Khanh', color: Colors.white, onTapLink: () {}),
          SizedBox(
            width: w * 0.05,
          )
        ],
      ),
    );
  }

  Widget _buildPaginationLayout(BuildContext context) {
    // if (_pageIndexList.isNotEmpty) _pageIndexList.clear();
    if (_totalPage == null) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: !_pageIndexList[0].isSelected,
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
          children: _pageIndexList
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
      routeAdmin,
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final bool isTouched = i == touchedIndex;
      switch (i) {
        case 0:
          return _buildPieChartData(context, isTouched, Color(0xff0293ee), 40);
        case 1:
          return _buildPieChartData(context, isTouched, Color(0xfff8b250), 30);
        case 2:
          return _buildPieChartData(context, isTouched, Color(0xff845bef), 15);
        case 3:
          return _buildPieChartData(context, isTouched, Color(0xff13d38e), 15);
        default:
          throw Error();
      }
    });
  }

  PieChartSectionData _buildPieChartData(
      BuildContext context, bool isTouched, Color color, double value) {
    final fontSize = isTouched ? 25.0 : 16.0;
    final radius = isTouched ? 145.0 : 140.0;
    return PieChartSectionData(
      color: color,
      value: value,
      title: '$value %',
      radius: radius,
      titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff)),
    );
  }

  Widget _buildLegendItem(BuildContext context, Legend legend,) {
    var w = MediaQuery.of(context).size.width;
    return MouseRegion(
      onHover: (val) {
        setState(() {
          _legends.forEach((element) {
            element.isHover = false;
          });
          legend.isHover = true;
        });
      },
      onExit: (val) {
        setState(() {
          legend.isHover = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: w * 0.1,
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: legend.isHover ? legend.color : Color(0xfffafafa),
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${legend.title}', style: GoogleFonts.roboto(color: legend.isHover ? Colors.white : legend.color, fontSize: 10,)),
            SizedBox(height: 8,),
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 4.0,
                  percent: legend.percent,
                  center: Text('${legend.value}', style: GoogleFonts.roboto(color: legend.isHover ?  Colors.white : legend.color, fontSize: 9,)),
                  backgroundColor: legend.backgroundColor,
                  progressColor: Colors.white,
                ),
                Spacer(),
                Text.rich(TextSpan(
                  children: [
                    TextSpan(text: 'total: ', style: GoogleFonts.roboto(color: legend.isHover ? Colors.white : legend.color, fontSize: 9,)),
                    TextSpan(text: '${(legend.percent * 100).toString().replaceAll('%', '')}', style: GoogleFonts.roboto(color: legend.isHover ? Colors.white : legend.color, fontSize: 20,fontWeight: FontWeight.w700)),
                  ]
                ))
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
  String title;
  double percent;
  String value;
  Color color;
  Color backgroundColor;
  bool isHover;

  Legend({this.title, this.percent, this.value, this.color, this.backgroundColor, this.isHover = false});
}
