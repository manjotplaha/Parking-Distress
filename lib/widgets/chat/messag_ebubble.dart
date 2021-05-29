import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  bool isMe;
  final String userName;
  final String userImage;
  bool isReciever;
  final String recieverName;
  final String recieverPhoneNumber;
  final String recieverVehicleNumber;
  final String userVehicleNumber;
  final Timestamp createdAt;
  final Key key;

  MessageBubble(
      this.message,
      this.userName,
      this.userImage,
      this.isMe,
      this.isReciever,
      this.recieverName,
      this.recieverPhoneNumber,
      this.recieverVehicleNumber,
      this.userVehicleNumber,
      this.createdAt,
      {this.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: if(isMe) {MainAxisAlignment.end} elseif(isReciever){MainAxisAlignment.start},
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: isMe
                  ? const EdgeInsets.fromLTRB(0, 0, 20, 0)
                  : const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                isMe
                    ? 'You, ${createdAt.toDate().hour}:${createdAt.toDate().minute}'
                    : '$recieverVehicleNumber, ${createdAt.toDate().hour}:${createdAt.toDate().minute}',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: isMe ? Color(0xffB2B9C5) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              // width: 140,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 2 / 3),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                          color: isMe
                              ? Theme.of(context)
                                  .accentTextTheme
                                  .bodyText1
                                  .color
                              : Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// Text(
//                   isMe ? 'You' : recieverVehicleNumber,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
