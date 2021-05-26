import 'package:chat_app/widgets/chat/messag_ebubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final String recieverVehicleNumber;
  final String recieverid;
  final String senderId;

  Messages(this.recieverVehicleNumber, this.recieverid, this.senderId);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var chatDocs = chatSnapshot.data.docs;
        return Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemCount: chatSnapshot.data.docs.length,
                    itemBuilder: (ctx, index) {
                      return MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['userName'],
                          chatDocs[index]['userImage'],
                          chatDocs[index]['userId'] ==
                              FirebaseAuth.instance.currentUser.uid,
                          chatDocs[index]['recieverId'] == recieverid,
                          chatDocs[index]['recieverName'],
                          chatDocs[index]['recieverPhoneNumber'],
                          recieverVehicleNumber,
                          chatDocs[index]['uservehicleNumber']);
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
