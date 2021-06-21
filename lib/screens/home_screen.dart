import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CVModel> _cvList = [];
  MasterData _masterData;

  @override
  void initState() {
    // Get master data
    _fetchMasterData();
    // Get list cv
    _fetchCVList();
    super.initState();
  }

  // Fetch master data to create/edit cv
  _fetchMasterData() async {
    BlocProvider.of<CVBloc>(context).add(RequestGetCVListEvent());
  }

  _fetchCVList() async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<CVBloc>(context)
        .add(RequestGetCVModel(pref.getAccessToken));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CVBloc, CVState>(
      builder: (context, state) => _buildUI(context),
      listener: (context, state) {
        if (state is CVListLoading) {
          showProgressBar(context, true);
        } else if (state is GetCVListSuccess) {
          setState(() {
            _masterData = state.masterData;
          });
          print('Home MasterData: ${_masterData.summary.first.role}');
        } else if (state is GetCVListError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is GetCvSuccess) {
          _cvList = state.cvList;
        } else if (state is GetCvError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        }
      },
      buildWhen: (context, state) => state is GetCVListSuccess,
    );
  }

  Widget _buildUI(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: w * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LinkText(
                      text: 'Admin page',
                      color: Color(0xff434b65),
                      onTapLink: () {
                        navKey.currentState.pushNamed(
                          routeAdmin,
                        );
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  LinkText(
                      text: 'Logout',
                      color: Colors.red,
                      onTapLink: () async {
                        final pref = await SharedPreferencesService.instance;
                        pref.removeAccessToken();
                        navKey.currentState.pushNamedAndRemoveUntil(
                            routeLogin, (route) => false);
                      })
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: w * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ',
                    style: CommonStyle.size16W400hintTitle(context)
                        .copyWith(fontSize: 18),
                  ),
                  Text(
                    'Username',
                    style: CommonStyle.size16W400hintTitle(context)
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            _header(context),
            SizedBox(
              height: 50.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 100),
              child: Divider(color: Colors.black),
            ),
            SizedBox(
              height: 50.0,
            ),
            _buildListCV(context)
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonCommon(
                  buttonText: 'Create CV',
                  onClick: () {
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
                              projectDescription: '')
                        ],
                        technicalSummaryList: [],
                        status: false,
                        educationList: [],
                        skills: [],
                        professionalList: [],
                        certificateList: [],
                        gender: 'Female');

                    navKey.currentState
                        .pushNamed(routeCreateCV, arguments: model);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Draft',
                        style: CommonStyle.size16W400hintTitle(context),
                      ),
                    )
                  ]),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Completed',
                          style: CommonStyle.size16W400hintTitle(context)),
                    )
                  ]),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '5',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '12',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Create list CV
  Widget _buildListCV(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(32),
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'No.',
                      style: CommonStyle.size16W400hintTitle(context)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: Text('Name',
                      textAlign: TextAlign.left,
                      style: CommonStyle.size16W400hintTitle(context)
                          .copyWith(fontWeight: FontWeight.w700))),
              Expanded(
                  flex: 1,
                  child: Text('Status',
                      textAlign: TextAlign.center,
                      style: CommonStyle.size16W400hintTitle(context)
                          .copyWith(fontWeight: FontWeight.w700))),
              Expanded(
                  flex: 2,
                  child: Text('Actions',
                      textAlign: TextAlign.center,
                      style: CommonStyle.size16W400hintTitle(context)
                          .copyWith(fontWeight: FontWeight.w700)))
            ],
          ),
          ListView.builder(
              padding: EdgeInsets.only(top: 30),
              shrinkWrap: true,
              itemCount: _cvList.length,
              itemBuilder: (context, index) {
                final item = _cvList[index];
                return _buildCVItem2(context, item, index);
              }),
        ],
      ),
    );
  }

  Widget _buildCVItem2(BuildContext context, CVModel model, int index) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: Text('${index + 1}')),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('${model.name}'), Text('${model.position}')],
                )),
            Expanded(
                flex: 1,
                child: Text(
                  'Status',
                  textAlign: TextAlign.center,
                )),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        tooltip: 'Preview',
                        color: Color(0xff434b65),
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 16,
                        ),
                        onPressed: () {}),
                    IconButton(
                        tooltip: 'Download',
                        color: Color(0xff434b65),
                        icon: Icon(Icons.download_rounded, size: 16),
                        onPressed: () {}),
                    IconButton(
                        tooltip: 'Delete',
                        color: Color(0xff434b65),
                        icon: Icon(Icons.delete, size: 16),
                        onPressed: () {})
                  ],
                ))
          ],
        ));
  }

  // Build item CV
  Widget _buildCVItem(BuildContext context, CVModel model) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              navKey.currentState.pushNamed(routeCreateCV, arguments: model),
          child: Container(
            margin: EdgeInsets.only(bottom: 50.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: const Offset(
                        0.0,
                        2.0,
                      ),
                      blurRadius: 2.0,
                      spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ], border: Border.all(width: 1.0, color: Colors.black)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Position',
                                style: CommonStyle.size16W400hintTitle(context)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: w * 0.005,
                                child: Text(':'),
                              ),
                              Text(
                                '${model.position}',
                                style: CommonStyle.size16W400hintTitle(context),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Email',
                                style: CommonStyle.size16W400hintTitle(context)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: w * 0.005,
                                child: Text(':'),
                              ),
                              Text(
                                '${model.email}',
                                style: CommonStyle.size16W400hintTitle(context),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              tooltip: 'Preview',
                              color: Color(0xff434b65),
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {}),
                          IconButton(
                              tooltip: 'Download',
                              color: Color(0xff434b65),
                              icon: Icon(Icons.download_rounded),
                              onPressed: () {}),
                          IconButton(
                              tooltip: 'Delete',
                              color: Color(0xff434b65),
                              icon: Icon(Icons.delete),
                              onPressed: () {})
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: -20,
                    left: 30,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1.0, color: Colors.black)),
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          '${model.name} (Mr.)',
                          textAlign: TextAlign.center,
                          style: CommonStyle.black400Size22(context),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
