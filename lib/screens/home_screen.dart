import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/screens/viewPageCreatecv/section_one_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cv_maker/extensions/size_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CVModel> _cvList = [];

  @override
  void initState() {
    _cvList.addAll([
      CVModel(
          name: 'KHANH Tran Quoc',
          position: 'Mobile Developer',
          email: 'khanhtq@yahoo.com',
          certificateList: [
            Certificate(certificateNm: "Certificate 1", certificateYear: '2019')
          ],
          role: Role(roleNm: 'BA', level: ['BA1'], technicals: ['BAa']),
          skills: [
            Skill(skillNm: 'Program Language', skillData: 'Java, NodeJS')
          ],
          professionalList: [
            Professional(
                roleNm: 'Mobile Developer',
                companyNm: 'TECHVIFY',
                startDate: 'Mar-2019',
                endDate: 'Mar-2020',
                locationNm: 'Hanoi Vietnam',
                responsibilities: ['Coding', 'Testing'])
          ],
          educationList: [
            Education(
                schoolNm: 'FPT University',
                majorNm: 'Information Technology',
                classYear: '2019')
          ],
          gender: 'Male',
          highLightProjectList: [
            HighLightProject(
                projectNm: 'CV-Maker',
                teamSize: '2',
                position: 'Frontend Developer',
                projectDescriptionNm: 'Create tool for CV create',
                technologies: ['Node JS', 'Flutter'],
                responsibility: ['Coding frontend', 'Suggest something']),
          ],
          status: true,
          technicalSummaryList: [
            '5 years’ experiences in software development specialize in web backend development. ',
            'Good understanding of server-side templating technical, system architectural. ',
            'Many experiences working with API design, DB design. '
          ]),
      // CVModel(
      //     name: 'Nguyen Van B',
      //     position: 'CEO',
      //     status: false,
      //     email: 'khanhtq@yahoo.com',
      //     technicalSummaryList: ['hoc ngu nhu trau', 'monster', 'bo lao']),
      // CVModel(
      //     name: 'Nguyen Thi C',
      //     position: 'CEO',
      //     status: true,
      //     email: 'khanhtq@yahoo.com',
      //     technicalSummaryList: ['hoc gioi', 'dep zai', 'bo lao'])
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Logout'),
              ],
            ),
            Row(
              children: [
                Text(
                  'Welcome ,',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Username',
                  style: CommonStyle.size22W4005c5c5c(context),
                ),
              ],
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Container(
                child: TextButton(
                    onPressed: () {
                      CVModel model = CVModel(
                          name: '',
                          email: '',
                          position: '',
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
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.7 / 3.5,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: const Offset(
                            2.0,
                            2.0,
                          ),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ], border: Border.all(width: 0.5, color: Colors.black)),
                      child: Text(
                        'Add new',
                        style: TextStyle(color: Colors.black),
                      ),
                    )),
              ),
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
                      child: Text('Draft'),
                    )
                  ]),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Completed'),
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
    return Expanded(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 30),
            itemCount: _cvList.length,
            itemBuilder: (context, index) {
              final item = _cvList[index];
              return _buildCVItem(context, item);
            }));
  }

  // Build item CV
  Widget _buildCVItem(BuildContext context, CVModel model) {
    return InkWell(
      onTap: () =>
          navKey.currentState.pushNamed(routeCreateCV, arguments: model),
      child: Container(
        margin: EdgeInsets.only(bottom: 50.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              margin: EdgeInsets.symmetric(horizontal: 40),
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
                      Text('Position : ${model.position}'),
                      Text('Position : ${model.email}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        model.status == true ? 'Completed' : 'Draft',
                        style: CommonStyle.size20W400black(context),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Icon(
                        Icons.circle,
                        size: 30.0,
                        color: model.status == true
                            ? Colors.lightGreen
                            : Colors.yellow,
                      )
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
    );
  }
}
