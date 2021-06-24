import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/master_bloc/get_master_data_bloc/cv_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/helper.dart';
import 'package:flutter_cv_maker/models/cv_model/admin_page_model.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CVModel> _cvList = [];
  MasterData _masterData;
    List<int> arrayIndex =[];
    bool status = false;
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
      builder: (context, state) => _buildHomePage(context),
      listener: (context, state) {
        if (state is CVListLoading) {
          showProgressBar(context, true);
        } else if (state is GetMasterDataSuccess) {
          setState(() {
            _masterData = state.masterData;
          });
          print('Home MasterData: ${_masterData.summary.first.role}');
        } else if (state is GetMasterDataError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is GetCvListSuccess) {
          _cvList = state.cvList;
        } else if (state is GetCvListError) {
          showProgressBar(context, false);
          showAlertDialog(
              context, 'Error', state.message, () => Navigator.pop(context));
        } else if (state is DeleteCvSuccess) {
          showProgressBar(context, false);
          _fetchCVList();
          showAlertDialog(context, 'Success', 'Delete CV success!',
              () => Navigator.pop(context));
        } else if (state is DeleteCvError) {
          showProgressBar(context, false);
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
      backgroundColor: Color(0xfffbfbfb),
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
    for(int i=0;i< _cvList.length;i++){
      if(_cvList[i].status== false){
        draft.add(i);
      }else{
        complete.add(i);
      }
    }
    var w = MediaQuery.of(context).size.width;
    return Container(
        color: Color(0xFF000034),
        // padding: EdgeInsets.only(top: w * 0.05),F'F
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: w * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.lightBlue, width: 2)),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      )),
                  SizedBox(
                    width: 16,
                  ),
                  LinkText(
                      text: 'Kelvin Khanh',
                      color: Colors.white,
                      onTapLink: () {
                        navKey.currentState.pushNamed(
                          routeAdmin,
                        );
                      }),
                  SizedBox(
                    width: w * 0.05,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 10),
                      child: Text('${monthYear(DateTime.now())}',style: CommonStyle.size12W400black(context),),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(height:1,color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Expanded(child: Column(
                          children: [
                            Icon(Icons.summarize,color:Colors.lightGreen),
                            SizedBox(height: 5,),
                           Text.rich(TextSpan(
                             children: [
                               TextSpan(text: '${_cvList.length} ', style: CommonStyle.size16W400hintTitle(context).copyWith(fontWeight: FontWeight.w700)),
                               TextSpan(text: 'Total', style: CommonStyle.grey400Size22(context).copyWith(fontSize: 10)),
                             ]
                           ))
                          ],
                        )),
                        Expanded(child: Column(
                          children: [
                            Icon(Icons.timelapse,color: Colors.yellow,),
                            SizedBox(height: 5,),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: '${draft.length} ', style: CommonStyle.size16W400hintTitle(context).copyWith(fontWeight: FontWeight.w700)),
                                  TextSpan(text: 'Draft', style: CommonStyle.grey400Size22(context).copyWith(fontSize: 10)),
                                ]
                            ))
                          ],
                        )),
                        Expanded(child: Column(
                          children: [
                            Icon(Icons.check_circle,color:Colors.lightGreen),
                            SizedBox(height: 5,),
                            Text.rich(TextSpan(
                                children: [
                                  TextSpan(text: '${complete.length} ', style: CommonStyle.size16W400hintTitle(context).copyWith(fontWeight: FontWeight.w700)),
                                  TextSpan(text: 'Completed', style: CommonStyle.grey400Size22(context).copyWith(fontSize: 10)),
                                ]
                            ))
                          ],
                        )),

                      ],
                    ),
                    SizedBox(height: 16,),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(height: 1,color: Colors.grey,),
                    )
                  ],
                ),
                width: w,
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40))),
              ),
            ),
          ],
        ));
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
                                  onclick: (){
                                      for(int i = 0; i < _cvList.length ;i++){
                                        setState(() {
                                          arrayIndex.clear();
                                          arrayIndex.add(i);
                                         // print(arrayIndex);
                                        });
                                      }

                                  },
                                  text: 'All',
                                  sizeBorder: true,
                                ),
                                FilterCustom(
                                  onclick: (){
                                   setState(() {
                                     status = true;
                                   });
                                         // for(int i = 0; i < _cvList.length ;i++){
                                         //   if(_cvList[i].status == false){
                                         //     setState(() {
                                         //       arrayIndex.clear();
                                         //       arrayIndex.add(i);
                                         //       //print(arrayIndex);
                                         //     });
                                         //   }
                                         // }

                                  },
                                  text: 'Draft',
                                  sizeBorder: true,
                                ),
                                FilterCustom(
                                  onclick: (){
                                      for(int i = 0; i < _cvList.length ;i++){
                                        if(_cvList[i].status == true){
                                       setState(() {
                                         arrayIndex.clear();
                                         arrayIndex.add(i);
                                         //print(arrayIndex);
                                       });
                                        }
                                      }

                                  },
                                  text: 'Completed',
                                  sizeBorder: true,
                                ),
                                FilterCustom(
                                  text: 'Role',
                                  sizeBorder: true,
                                ),
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
                    true ,1),
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
            uiuxdesign: ''
          )
        ],
        technicalSummaryList: [],
        status: false,
        educationList: [],
        skills: [],
        professionalList: [],
        certificateList: [],
        gender: '');

    navKey.currentState.pushNamed(routeCreateCV, arguments: model);
  }
  // Create list CV
  Widget _buildListCV(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 20,),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.078),
          child: Divider(height: 1,color: Colors.grey,),
        ),
        SizedBox(height: 20,),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.078),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming',style: CommonStyle.size14W700black(context),),
            ],
          ),
        ),
        SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 30),
                shrinkWrap: true,
                itemCount: _cvList.length,
                itemBuilder: (context, index) {
                  final item = _cvList[index];
                  return _buildCVItem(context, item, false,index);
                }),
          ),
        ),
      ],
    );
  }

  // Build item CV
  Widget _buildCVItem(BuildContext context, CVModel model, bool isRecent , int index) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: !isRecent ? w * 0.01 : 0,
          horizontal: !isRecent ? w * 0.074 : 0),
      decoration:
          BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          onTap: () =>
              navKey.currentState.pushNamed(routeCreateCV, arguments: model),
          child: Container(
            decoration: BoxDecoration(
            ),
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
                          height: MediaQuery.of(context).size.height*0.087,
                          width: 3.5,
                          decoration: BoxDecoration(
                              color:model.status ? Colors.lightGreen :Colors.red.shade400,
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(50.0),bottomLeft:Radius.circular(50.0))
                          ),
                        ),
                        SizedBox(width: 30,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '11:00 AM',
                              style: CommonStyle.size12W400xam(context),
                            ),
                            Text('Yesterday', style: CommonStyle.size10xam(context))
                          ],
                        ),
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width*0.005),
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
                              Icon(Icons.location_pin,size: 16,color: Colors.grey,),
                              SizedBox(width: 6,),
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
                          onPressed: () async {
                            final pref =
                                await SharedPreferencesService.instance;
                            BlocProvider.of<CVBloc>(context).add(
                                RequestDeleteCvEvent(
                                    pref.getAccessToken, _cvList[index].id));
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
}
