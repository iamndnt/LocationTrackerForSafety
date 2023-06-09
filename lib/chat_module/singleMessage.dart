import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

class SingleMessage extends StatelessWidget {
  final String? message;
  final bool? isMe;
  final String? image;
  final String? type;
  final String? friendName;
  final String? myName;
  final Timestamp? date;

  const SingleMessage(
      {super.key,
        this.message,
        this.isMe,
        this.image,
        this.type,
        this.friendName,
        this.myName,
        this.date});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    DateTime d = DateTime.parse(date!.toDate().toString());
    String cdate = "${d.hour}" + ":" + "${d.minute}";
    return Column(
      crossAxisAlignment: isMe!? CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        Visibility(child: Row(
          children: [
            SizedBox(width: 8,),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if (!snapshot.hasData) {
                  return Center(child: progressIndicator(context));
                }
                for(int i=0;i<snapshot.data!.docs.length;i++){
                  final d = snapshot.data!.docs[i];
                  if(friendName?.compareTo(d['id'])==0)
                    return Text(d['name']!,
                      style: TextStyle(
                          fontSize: 10
                      ),);
                }
                return Text('');
              },
            ),
          ],
        ),
          visible: !isMe!,),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20 * 0.75,
            vertical: 20 / 2,
          ),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(isMe! ? 1 : 0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            message!,
            style: TextStyle(
              color: isMe!
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ),Text("$cdate",
          style: TextStyle(
              fontSize: 10
          ),),
      ],
    );
  }
}
