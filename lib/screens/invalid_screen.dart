import 'package:flutter/material.dart';

class InvalidQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F4),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        shadowColor: Color.fromRGBO(0, 0, 0, 0),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/invalid-qr.png'),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 3,
                endIndent: 40,
                indent: 40,
              ),
              SizedBox(
                height: 15,
              ),
              Text('Invalid QR',
                  style: TextStyle(fontSize: 30, color: Colors.red)),
              SizedBox(
                height: 15,
              ),
              Text('Please Scan a Valid QR Code',
                  style: TextStyle(fontSize: 20, color: Colors.red)),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
