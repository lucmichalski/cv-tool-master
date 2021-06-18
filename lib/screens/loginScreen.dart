import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/authen_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:universal_html/html.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // login request
  Future<void> _requestLogin() async {
    BlocProvider.of<AuthBloc>(context)
        .add(RequestAuthenEvent(emailController.text, passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc,AuthenState>(
        builder: (context, state) => _buildUI(context),
        listener: (context, state) {
          if (state is AuthLoading) {
            showProgressBar(context, true);
          } else if (state is AuthenSuccess) {
            showProgressBar(context, false);
            navKey.currentState.pushNamedAndRemoveUntil(routeHome, (route) => false);
            print('Success');
          } else if (state is AuthenError) {
            showProgressBar(context, false);
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          }
        });
  }

  Widget _buildUI(BuildContext context) {
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
                          TextFieldCommon(
                            maxLines: 1,
                            controller: emailController,
                            label: 'Email',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFieldCommon(
                            isObscure: true,
                            maxLines: 1,
                            controller: passwordController,
                            label: 'Password',
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _requestLogin();
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
