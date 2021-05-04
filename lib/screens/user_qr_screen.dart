import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Print QR'),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else {
                  var userSnapshot = snapshot.data.docs;
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QrImage(
                        data: userSnapshot[0]['vehicleNumber'],
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Vehicle Plate No.: ${userSnapshot[0]['vehicleNumber']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Vehicle Model: ${userSnapshot[0]['vehicleModelNumber']}',
                        // userSnapshot[0]['vehicleModelNumber'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Vehicle Name: ${userSnapshot[0]['userName']}',
                        // userSnapshot[0]['userName'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Disclaimer: Print this QR Code and Paste it on the Front Mirror of your car',
                        textAlign: TextAlign.center,
                      )
                    ],
                  );
                }
              })),
    );
  }
}
