import 'dart:io';

import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/invalid_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: _buildQrView(context)),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(children: [
      QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
      ),
      Positioned(
          top: 90,
          // right: MediaQuery.of(context).size.width / 4,
          left: MediaQuery.of(context).size.width / 3.3,
          child: Text(
            'Scan QR Code',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
      Positioned(
        bottom: 50,
        right: MediaQuery.of(context).size.width / 7,
        left: MediaQuery.of(context).size.width / 7,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          height: 70,
          width: 250,
          // color: Colors.grey[400],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.flash_on,
                  size: 30,
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.flip_camera_ios_outlined,
                  size: 30,
                ),
                onPressed: () async {
                  await controller?.flipCamera();
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.pause,
                  size: 30,
                ),
                onPressed: () async {
                  await controller?.pauseCamera();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.play_arrow_outlined,
                  size: 30,
                ),
                onPressed: () async {
                  await controller?.resumeCamera();
                },
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    dynamic recieveruserId;
    dynamic recieverPhoneNumber;
    dynamic recieveruserName;
    dynamic recieverVehicleNumber;
    dynamic recieverVehName;
    Iterable mapper;
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      print(scanData.code);

      var senderId = FirebaseAuth.instance.currentUser.uid;
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .where('vehicleNumber', isEqualTo: scanData.code.toString())
            .get()
            .then((value) {
          mapper = value.docs.map((e) async {
            recieverPhoneNumber = e.data()['phoneNumber'];
            recieveruserId = e.data()['userId'];
            recieveruserName = e.data()['userName'];
            recieverVehName = e.data()['vehicleModelNumber'];
            recieverVehicleNumber = scanData.code.toString();
          });
          print('mapper ${mapper.first}');
        });
        if (scanData != null) {
          print('scanData is not null');
          if (mapper.first != null) {
            print('Valid QR');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => ChatScreen(scanData.code.toString(),
                    recieveruserId, senderId, recieverVehName),
              ),
            );
            controller.stopCamera();
          }
        }
      } catch (e) {
        print(e);
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => InvalidQR()));
      }

      result = scanData;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
