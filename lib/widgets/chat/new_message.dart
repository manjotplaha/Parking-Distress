import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewMessage extends StatefulWidget {
  var vehNumber;
  NewMessage(this.vehNumber);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  Future<void> _launched;
  bool _messageSent = false;
  final _controller = new TextEditingController();
  var _eneterdMessage = '';
  dynamic recieverPhoneNumber;
  dynamic recieveruserId;
  dynamic recieveruserName;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    await FirebaseFirestore.instance
        .collection('users')
        .where('vehicleNumber', isEqualTo: widget.vehNumber)
        .get()
        .then((value) {
      print(value.docs.map((e) async {
        recieverPhoneNumber = e.data()['phoneNumber'];
        recieveruserId = e.data()['userId'];
        recieveruserName = e.data()['userName'];
      }));
    });

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    print(widget.vehNumber);
    await FirebaseFirestore.instance.collection('chat').add({
      'text': _eneterdMessage,
      'createdAt': Timestamp.now(),
      'userName': userData['userName'],
      'userId': user.uid,
      'recieverId': recieveruserId,
      'recieverPhoneNumber': recieverPhoneNumber,
      'recieverName': recieveruserName,
      'userImage': userData['image_url'],
      'uservehicleNumber': userData['vehicleNumber'],
      'userPhoneNumber': userData['phoneNumber'],
      'userVehicleModel': userData['vehicleModelNumber']
    });
    _controller.clear();
  }

  final List<String> problems = [
    'Car Theft',
    'Vandalism',
    'Car Blocking',
    'Headlights On',
    'Cabin Lights On',
    'Car Left Unlocked',
    'Flat Tire'
  ];
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          onPressed: () {
            launch("tel://21213123123");
          },
          child: Icon(Icons.phone),
        ),
        if (_messageSent == false)
          (Column(
            children: [
              Text(
                'Select an option to Notify:',
                textAlign: TextAlign.start,
              ),
              Container(
                alignment: Alignment.bottomRight,
                width: 250,
                height: 250,
                margin: EdgeInsets.only(top: 8),
                // padding: EdgeInsets.all(8),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      itemCount: problems.length,
                      itemBuilder: (ctx, i) => SizedBox(
                            // height: 25,
                            child: ListTile(
                              title: Column(
                                children: [
                                  Text(problems[i]),
                                  Divider(
                                    thickness: 1,
                                  )
                                ],
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16.0),
                              dense: true,
                              onTap: () {
                                setState(() {
                                  _eneterdMessage = problems[i];
                                  _sendMessage();
                                  _messageSent = true;
                                });
                              },
                            ),
                          )),
                ),
              ),
            ],
          ))
        else
          Expanded(
            child: (Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                    onChanged: (value) {
                      setState(() {
                        _eneterdMessage = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _eneterdMessage.trim().isEmpty
                      ? null
                      : () {
                          _sendMessage();
                        },
                )
              ],
            )),
          )
      ],
    );
  }
}

// FirebaseFirestore.instance
//     .collection('users')
//     .where('vehicleNumber', isEqualTo: widget.vehNumber)
//     .get()
//     .then((value) {
//   print(value.docs.map((e) => recieveruserId = e.data()['userId']));
// });

// FirebaseFirestore.instance
//     .collection('users')
//     .where('vehicleNumber', isEqualTo: widget.vehNumber)
//     .get()
//     .then((value) {
//   print(value.docs.map((e) => recieveruserName = e.data()['userName']));
// });
