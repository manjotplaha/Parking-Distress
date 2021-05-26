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
      {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // if (isReciever)
        Row(
          // mainAxisAlignment: if(isMe) {MainAxisAlignment.end} elseif(isReciever){MainAxisAlignment.start},
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isMe ? userVehicleNumber : recieverVehicleNumber,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .bodyText1
                                .color),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: -10,
            left: isMe ? null : 120,
            right: isMe ? 120 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            )),
      ],
      overflow: Overflow.visible,
    );
  }
}

// reciever id
// userid aka sender id

// if currenruserId == senderId  , reciverId == reciever id=> is Me true
//if userid == recieverid, reciever id == senderId ==> isMe
