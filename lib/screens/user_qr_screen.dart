import 'dart:convert';
import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/user_qr_download.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
// import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class UserQR extends StatefulWidget {
  @override
  _UserQRState createState() => _UserQRState();
}

class _UserQRState extends State<UserQR> {
  final _formKey = GlobalKey<FormState>();

  GlobalKey _globalKey = GlobalKey();

  String _userName = '';
  String _userPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print('$info');
  }

  Future _capturePng() async {
    try {
      print('Inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      var bs64 = base64Encode(pngBytes);
      // print(pngBytes);
      // var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
      // print(filePath);
      // final String dir = (await getApplicationDocumentsDirectory()).path;
      // final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      // File capturedFile = File(fullPath);
      // await capturedFile.writeAsBytes(pngBytes);
      // print(capturedFile.path);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('User Profile'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => AuthScreen()));
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _globalKey,
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc('$userId')
                .get(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QrImage(
                        data: snapshot.data.data()['vehicleNumber'],
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      Divider(
                        thickness: 3,
                        indent: 50,
                        endIndent: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 2,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vehicle Type: ${snapshot.data.data()['vehicleNumber']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Vehicle Type: ${snapshot.data.data()['vehicletype']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Vehicle Model: ${snapshot.data.data()['vehicleModelNumber']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: _modalBottomSheetInformation,
                              child: Text(
                                'EDIT',
                                style: TextStyle(color: Colors.amber[300]),
                              ))),
                      Container(
                        margin: EdgeInsets.zero,
                        width: MediaQuery.of(context).size.width * 2,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name : ${snapshot.data.data()['userName']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Email : ${snapshot.data.data()['email']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Contact No.: ${snapshot.data.data()['phoneNumber']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'DOB : ${snapshot.data.data()['dob']}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => UserQRDownload()));
        },
        tooltip: 'Save The Or Code',
        child: Icon(Icons.save_alt_outlined),
      ),
    );
  }

  Future _modalBottomSheetInformation() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            height: MediaQuery.of(context).size.height -
                (MediaQuery.of(context).size.height / 2),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [Text('Edit'), Icon(Icons.edit)],
                    ),
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
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _trySubmit,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text('UPDATE',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ))),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white);
  }

  updateInformation(String uName, String phoneNo) async {
    String userId = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'userName': '$uName', 'phoneNumber': '$phoneNo'});
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save(); //used to invoke on pressed button
      await updateInformation(_userName, _userPhoneNumber);
      FocusScope.of(context).unfocus();
    }
  }
}
