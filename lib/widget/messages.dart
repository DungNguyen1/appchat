import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:chatsapp/widget/_messages.dart';

class Messages extends StatelessWidget {
  Future getUser() async {
    final user = await FirebaseAuth.instance.currentUser;

    return user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (ctx, futuresnapshot) {
          if (futuresnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (ctx, chatsnapshot) {
                if (chatsnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final List documents = chatsnapshot.data!.docs;
                return ListView.builder(
                    reverse: true,
                    itemCount: documents.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                          documents[index]['text'],
                          documents[index]['name'],
                          documents[index]['userImage'],
                          documents[index]['userId'] == futuresnapshot.data,
                          key: ValueKey(documents[index].id),
                        ));
              });
        });
  }
}
