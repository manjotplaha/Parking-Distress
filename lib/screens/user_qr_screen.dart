import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Print QR'),
        ),
        body: FutureBuilder(
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
                    child: Column(children: [
                      QrImage(
                        data: snapshot.data.data()['vehicleNumber'],
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
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
                      SizedBox(height: 50),
                      Text(
                        'Disclaimer: Print this QR Code and Paste it on the Front Mirror of your car',
                        textAlign: TextAlign.center,
                      ),
                    ]));
            }));
  }
}
