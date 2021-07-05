import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/authen_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/progress_bar_dialog.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
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
  bool _isChange ;
  // login request
  Future<void> _requestLogin() async {
    BlocProvider.of<AuthBloc>(context)
        .add(RequestAuthEvent(emailController.text, passwordController.text));
  }
@override
  void initState() {
  _isChange = true;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc,AuthState>(
        builder: (context, state) => _buildUI(context),
        listener: (context, state) {
          if (state is AuthLoading) {
            showProgressBar(context, true);
          } else if (state is AuthSuccess) {
            showProgressBar(context, false);
            print('fullname : ${state.response.fullName}');
            navKey.currentState.pushNamedAndRemoveUntil(routeHome,(route) => false);
            print('Success');
          } else if (state is AuthError) {
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
            child: Card(
              elevation: 5,
              child: Container(
                //padding: EdgeInsets.all(90.0),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.6,
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
                child: Row(
                  children: [
                    Expanded(child: _buildLoginColumn(context)),

                    Expanded(child: Container(
                      child:  Image(image: AssetImage('image/tvf.jpg'),fit: BoxFit.cover,)
                    ),)
                  ],
                )
              ),
            ),),
      ),
    );
  }

  Widget _buildLoginColumn(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('CVs-Generator', style: CommonStyle.size48W700black(context).copyWith(color: kmainColor),),
                  ],
                ),
                SizedBox(height: 20,),
                TextFieldCommon(
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (val) {
                    setState(() {
                      _requestLogin();
                    });
                  },
                  maxLines: 1,
                  controller: emailController,
                  label: 'Email',
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldCommon(
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (val) {
                    setState(() {
                      _requestLogin();
                    });
                  },
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _isChange =!_isChange;
                      print(_isChange);
                    });
                  },
                   icon: _isChange ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
               ),
                  isObscure: _isChange,
                  maxLines: 1,
                  controller: passwordController,
                  label: 'Password',
                ),
                SizedBox(
                  height: 20.0,
                ),
                ButtonCommon(
                    buttonText: 'LOGIN',
                    onClick: () {
                      if (_formKey.currentState.validate()) {
                        _requestLogin();
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
