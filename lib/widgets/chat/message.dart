import 'package:chat_app/widgets/chat/messag_ebubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
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
        final chatDocs = chatSnapshot.data.docs;
        return Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: chatSnapshot.data.docs.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['userName'],
                          chatDocs[index]['userImage'],
                          chatDocs[index]['userId'] ==
                              FirebaseAuth.instance.currentUser.uid,
                        )),
              ),
            ],
          ),
        );
      },
    );
  }
}
