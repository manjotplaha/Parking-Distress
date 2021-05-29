import 'dart:io';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/widgets/chat/message.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  String recieverVehicleNumber;
  String recieverid;
  String senderId;
  String recieverVehName;

  ChatScreen(this.recieverVehicleNumber, this.recieverid, this.senderId,
      this.recieverVehName);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fbm = FirebaseMessaging();

  @override
  void initState() {
    registerNotification();
    super.initState();
  }

  void registerNotification() {
    fbm.requestNotificationPermissions(); //for ios permissions
    fbm.configure(onMessage: (msg) async {
      print(msg);
      return;
    }, onLaunch: (msg) async {
      print(msg);
      return;
    }, onResume: (msg) async {
      return;
    });
    fbm.requestNotificationPermissions(const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: true));

    fbm.getToken().then((token) {
      print('token $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({'pushToken': token});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F4),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
            '${widget.recieverVehicleNumber} || ${widget.recieverVehName}'),
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
        // physics: NeverScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            children: [
              Expanded(
                  child: Messages(widget.recieverVehicleNumber,
                      widget.recieverid, widget.senderId)),
              Align(
                  alignment: Alignment.bottomRight,
                  child: NewMessage(widget.recieverVehicleNumber))
            ],
          ),
        ),
      ),
    );
  }
}
