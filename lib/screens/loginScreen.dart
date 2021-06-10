import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -150,
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: Text(
                'CV Maker',
                style: CommonStyle.size48W700black(context),
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(90.0),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
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
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _InputFormLogin('Email:', emailController,
                              'Please enter your email'),
                          SizedBox(
                            height: 20,
                          ),
                          _InputFormLogin('Password:', passwordController,
                              'Please enter your password'),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  navKey.currentState.pushNamed(routeHome);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width:
                                    MediaQuery.of(context).size.width * 0.7 / 3,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: const Offset(
                                        1.0,
                                        1.0,
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
                                  ],
                                ),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -80,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  width: 150,
                  height: 150,
                )),
          ],
        )),
      ),
    );
  }
}

class _InputFormLogin extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String errorText;

  const _InputFormLogin(this.title, this.controller, this.errorText);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return errorText;
              }
              return null;
            },
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
            ),
            controller: controller,
          )
        ],
      ),
    );
  }
}
