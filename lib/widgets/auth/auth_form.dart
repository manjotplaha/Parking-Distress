import 'dart:io';
import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
      String email,
      String password,
      String userName,
      String vehicleType,
      String vehicleNumber,
      String vehicleRcNumber,
      String phoneNumber,
      String dob,
      String vehicleModelNumber,
      File image,
      bool isLogin,
      BuildContext context) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true; //if user is already signed up or not

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userVehlicleType = '';
  var _userVehicleNumber = '';
  var _userVehicleRcNumber = '';
  var _userPhoneNumber = '';
  var _userDOB = '';
  var _userVehicleModel = '';
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState
        .validate(); //invoke the validator propertes of form
    if (_userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save(); //used to invoke on pressed button
      widget.submitFn(
          _userEmail.trim(),
          _userName.trim(),
          _userPassword.trim(),
          _userVehlicleType,
          _userVehicleNumber,
          _userVehicleRcNumber,
          _userPhoneNumber,
          _userDOB,
          _userVehicleModel,
          _userImageFile,
          _isLogin,
          context);
      FocusScope.of(context)
          .unfocus(); //to hide the keyboard when the values have beenn filled

      //Use those values tp send to auth request..
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: ListView(children: [
        SizedBox(
          height: 75.0,
        ),
        Container(
            height: 125.0,
            width: 200.0,
            child: Stack(
              children: [
                Text('Hello',
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 60.0)),
                Positioned(
                    top: 50.0,
                    child: Text('There',
                        style:
                            TextStyle(fontFamily: 'Trueno', fontSize: 60.0))),
                Positioned(
                    top: 97.0,
                    left: 175.0,
                    child: Container(
                        height: 10.0,
                        width: 10.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green)))
              ],
            )),
        SizedBox(height: 25.0),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isLogin) UserImagePicker(_pickedImage),
              TextFormField(
                key: ValueKey('email'),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontFamily: 'Trueno',
                    fontSize: 12.0,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  labelText: 'Email Address',
                ),
                onSaved: (value) {
                  _userEmail = value;
                },
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please Enter a valid email address!';
                  }
                  return null;
                },
              ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('Username'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Username',
                  ),
                  onSaved: (value) {
                    _userName = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter a valid username';
                    }
                    return null;
                  },
                ),
              TextFormField(
                key: ValueKey('Password'),
                obscureText: true,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontFamily: 'Trueno',
                    fontSize: 12.0,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  labelText: 'Password',
                ),
                onSaved: (value) {
                  _userPassword = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 7) {
                    return 'Password must be atleast 7 charcters long.';
                  }
                  return null;
                },
              ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('Vehicle Type'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Vehicle Type',
                  ),
                  onSaved: (value) {
                    _userVehlicleType = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Vehicle Type';
                    }
                    return null;
                  },
                ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('Plate Number'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Plate Number',
                  ),
                  onSaved: (value) {
                    _userVehicleNumber = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Car\'s Plate Number';
                    }
                    return null;
                  },
                ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('Vehicle RC Number'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Vehicle RC Number',
                  ),
                  onSaved: (value) {
                    _userVehicleRcNumber = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Car\'s RC Number';
                    }
                    return null;
                  },
                ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('Vehicle Model'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Vehicle Model',
                  ),
                  onSaved: (value) {
                    _userVehicleModel = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter your Vehicle Model';
                    }
                    return null;
                  },
                ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('Phone Number'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Phone Number',
                  ),
                  onSaved: (value) {
                    _userPhoneNumber = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter your Phone Number';
                    }
                    return null;
                  },
                ),
              if (!_isLogin)
                TextFormField(
                  key: ValueKey('DOB'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontFamily: 'Trueno',
                      fontSize: 12.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'DOB',
                  ),
                  onSaved: (value) {
                    _userDOB = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter your DOB';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 12),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading) SizedBox(height: 50.0),
              GestureDetector(
                onTap: _trySubmit,
                child: Container(
                    height: 50.0,
                    child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: Center(
                            child: Text('LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Trueno'))))),
              ),
              SizedBox(height: 20.0),
              if (!widget.isLoading)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Container(
                    height: 50.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Center(
                        child: Text(
                          _isLogin
                              ? 'Create New Account'
                              : 'I Already have an account',
                          style: TextStyle(fontFamily: 'Trueno'),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
