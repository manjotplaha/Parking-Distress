import 'package:chat_app/widgets/chat/message.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  String vehicleNumber;
  ChatScreen(this.vehicleNumber);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions(); //for ios permissions
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      return;
    });
    fbm.getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var senderAuth = FirebaseAuth.instance.currentUser.uid;
    var recieverAuth = FirebaseFirestore.instance
        .collection('users')
        .where('vehicleNumber', isEqualTo: widget.vehicleNumber)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
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
                Expanded(child: Messages()),
                Align(
                    alignment: Alignment.bottomRight,
                    child: NewMessage(widget.vehicleNumber))
              ],
            )),
      ),
    );
  }
}
