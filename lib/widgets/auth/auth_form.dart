import 'dart:io';
import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  //To Validate email
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email should have @ and .';
    else
      return null;
  }

// To validate Date
  String validateDate(String value) {
    Pattern pattern =
        r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Date';
    else
      return null;
  }

  validateVehicleNumber(String value) async {
    dynamic recieveruserId;
    dynamic recieverPhoneNumber;
    dynamic recieveruserName;
    dynamic recieverVehicleNumber;
    dynamic recieverVehName;
    Iterable mapper;

    await FirebaseFirestore.instance
        .collection('users')
        .where('vehicleNumber', isEqualTo: value.toString())
        .get()
        .then((value) {
      mapper = value.docs.map((e) async {
        recieverPhoneNumber = e.data()['phoneNumber'];
        recieveruserId = e.data()['userId'];
        recieveruserName = e.data()['userName'];
        recieverVehName = e.data()['vehicleModelNumber'];
        // recieverVehicleNumber = scanData.code.toString();

        if (value.docs.length != 0) {
          print('error');
          return 'This Plate Number Already Exists';
        } else {
          print('no error');
          return null;
        }
      });
    });

    print(mapper.first);

    if (mapper.first != null) {
      print('here');
      return 'This Plate Number Already Exists'.toString();
    } else {
      print('here not');
      return null;
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState
        .validate(); //invoke the validator propertes of form
    if (!_isLogin) if (_userImageFile == null) {
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
                Text('Parking',
                    style: TextStyle(fontFamily: 'Trueno', fontSize: 50.0)),
                Positioned(
                    top: 50.0,
                    child: Text('Distress',
                        style:
                            TextStyle(fontFamily: 'Trueno', fontSize: 60.0))),
                Positioned(
                    top: 97.0,
                    left: 235.0,
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
                    hintText: 'example@example.com',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'Email Address',
                  ),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                  validator: (value) => value.isEmpty
                      ? 'Email is required'
                      : validateEmail(value)),
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
                    hintText: 'SUV/Saloon/HatchBack/Two-wheeler',
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
                    validator: (value) =>
                        value.isEmpty ? 'Plate No. is required' : null
                    // : validateVehicleNumber(value);
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
                    hintText: 'Innova/Esteem/Activa',
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
                    hintText: 'DD-MM-YYYY',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: 'DOB',
                  ),
                  onSaved: (value) {
                    _userDOB = value;
                  },
                  validator: (value) =>
                      value.isEmpty ? 'DOB is required' : validateDate(value),
                ),
              SizedBox(height: 12),
              if (widget.isLoading) CircularProgressIndicator(),
              SizedBox(height: 50.0),
              if (!widget.isLoading)
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
                        child: Text(
                          _isLogin ? 'LOGIN' : 'SIGN UP',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Trueno'),
                        ),
                      ),
                    ),
                  ),
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
