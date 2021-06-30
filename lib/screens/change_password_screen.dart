import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cv_maker/blocs/authen_bloc/bloc/authen_bloc.dart';
import 'package:flutter_cv_maker/common/alert_dialog_custom.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/routes/routes.dart';
import 'package:flutter_cv_maker/utils/shared_preferences_service.dart';
import 'package:flutter_cv_maker/utils/validation.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  Validation validation = new Validation();
  bool _isChangeCurrent ;
  bool _isChangeNew ;
  bool _isLastPassword ;
  TextEditingController _oldPassController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _newPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    _isChangeCurrent= true;
    _isChangeNew = true;
    _isLastPassword = true;
    super.initState();
  }
  _fetchCVList(String requestBody) async {
    final pref = await SharedPreferencesService.instance;
    BlocProvider.of<AuthBloc>(context).add(RequestUpdatePasswordEvent(
        pref.getAccessToken,requestBody));
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc ,AuthState>(builder: (context , state) =>_buildChangePass(context),
        listener: (context , state){
          if (state is UpdatePasswordSuccess) {
            showAlertDialog(context, 'Success', 'Update password  success!',
                    () => navKey.currentState.pushNamed(routeLogin));
          } else if (state is UpdatePasswordError) {
            showAlertDialog(
                context, 'Error', state.message, () => Navigator.pop(context));
          }
        });
  }
Widget _buildChangePass(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xffe9f0f3),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage('image/ic_logo_tvf.png'),fit: BoxFit.cover,height: 200,width: 500,),
              ],
            ),
            Text('Orchestrator',style: CommonStyle.size14W700black(context),),
            SizedBox(height: 15,),
            _formChange(context),


          ],
        ),
      ),
    );
}
  Widget _formChange(BuildContext context) {

    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 22.0,vertical: 16),
          child: Column(
            children: [
              Text('Reset your password',style: CommonStyle.size14W700black(context),),
              SizedBox(height: 20,),
              TextFieldCommon(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter your old password';
                  }
                  return null;
                },
                controller: _oldPassController,
                isObscure: _isLastPassword,
                maxLines: 1,
                label: 'Current password *',
                suffixIcon: IconButton(
                  splashRadius: 1,
                  hoverColor: Colors.transparent,
                  onPressed: (){
                    setState(() {
                      _isLastPassword =!_isLastPassword;
                    });
                  },
                  icon: _isLastPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 8,),
              TextFieldCommon(
                validator: (value){
                 // validation.checkValidPassword(context,value);
                  if(value == null || value.isEmpty){
                    return 'Please enter your new password';
                  }
                  return null;
                },
                controller: _newPassController,
                isObscure: _isChangeNew,
                maxLines: 1,
                label: 'New Password *',
                suffixIcon: IconButton(
                  splashRadius: 1,
                  hoverColor: Colors.transparent,
                  onPressed: (){
                    setState(() {
                      _isChangeNew =!_isChangeNew;
                    });
                  },
                  icon: _isChangeNew ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 8,),
              TextFieldCommon(
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please confirm new password';
                  }
                  return null;
                 // validation.checkValidPassword(context, value);
                },
                controller: _confirmPassController,
                isObscure: _isChangeCurrent,
                maxLines: 1,
                label: 'Confirm password',
                suffixIcon: IconButton(
                  splashRadius: 1,
                  hoverColor: Colors.transparent,
                  onPressed: (){
                    setState(() {
                      _isChangeCurrent =!_isChangeCurrent;
                    });
                  },
                  icon: _isChangeCurrent ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),

              ),
              SizedBox(height: 35.0,),
              ButtonCommon(
                borderRadius: 8,
                color: Colors.white,
                  textStyle:CommonStyle.white700Size22(context).copyWith(color:kmainColor),
                  border: Border.all(color: Colors.grey, width: 1),
                  buttonText: 'Change Password', onClick: () {
                  if(_formKey.currentState.validate()){
                    bool validateStructure(String value){
                      String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                      RegExp regExp = new RegExp(pattern);
                      return regExp.hasMatch(value);
                    }
                    print(validateStructure(_newPassController.text));
                    if(validateStructure(_newPassController.text) == true){
                      if(_newPassController.text == _confirmPassController.text){
                        String requestBody = json.encode({
                          'password_old': _oldPassController.text,
                          'password_new':_newPassController.text
                        });
                        _fetchCVList(requestBody);
                      }else{
                        showAlertDialog(context, 'Notification', 'The old password must be the same as the new password!',
                                () =>Navigator.pop(context));
                      }
                    }else{
                      showAlertDialog(context, 'Notification', 'Password must contain letters, numbers and special characters!',
                              () =>Navigator.pop(context));
                    }

                  }else{

                  }


              }),
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('© 2020 TECHVIFY. All Rights Reserved',style: CommonStyle.size10xam(context),),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}
