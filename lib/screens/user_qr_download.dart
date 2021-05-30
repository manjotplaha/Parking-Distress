import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQRDownload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .get(),
          builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined),
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 40),
                      // constraints: BoxConstraints(
                      //     maxHeight: MediaQuery.of(context).size.height,
                      //     maxWidth: MediaQuery.of(context).size.width),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        // backgroundBlendMode: BlendMode.color
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 40),
                                  children: [
                                TextSpan(text: 'Parking '),
                                TextSpan(text: 'Distress'),
                                TextSpan(
                                    text: '.',
                                    style: TextStyle(color: Colors.green))
                              ])),
                          QrImage(
                            data: snapshot.data.data()['vehicleNumber'],
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2,
                            height: 30,
                            endIndent: 30,
                            indent: 30,
                          ),
                          Text(
                            'Plate no.: ${snapshot.data.data()['vehicleNumber']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Car: ${snapshot.data.data()['vehicleModelNumber']}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 20),

                          Text(
                            'User ID: ${snapshot.data.data()['userId']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),

                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'NOTE: This Card must be clipped and pasted at your Front windscreen at all times.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                          // Text('${snapshot.data.data()['']}')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          'Directions: Screenshot and Print the above Card and paste it on your vehicle'),
                    )
                  ],
                ),
              );
          }),
    ));
  }
}
