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
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
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
                    if (!widget.isLoading)
                      MaterialButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'SignUp'),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account'
                            : 'I Already have an account'),
                      )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
