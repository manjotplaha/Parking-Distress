import 'dart:io';

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

  ChatScreen(this.recieverVehicleNumber, this.recieverid, this.senderId);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.recieverVehicleNumber),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            focusColor: Theme.of(context).primaryIconTheme.color,
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
            )),
      ),
    );
  }
}
